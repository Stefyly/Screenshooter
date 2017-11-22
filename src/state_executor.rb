class Executor
  def initialize(browser)
    @browser = browser
    @current_state = 0
    @state_count = 0
  end
  attr_reader :state_count
  def set_comands(comands)
    @comands = comands
  end

  def next_command
    if @comands[@current_state].first.is_a?(Array)
      @comands[@current_state].each do |current_comand|
        execute_comand(current_comand)
      end
    else
      execute_comand(@comands[@current_state])
    end
    @current_state += 1
  end

  def commands_from_file(component_name)
    obj = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), '../states/' + parse_filename(component_name))))
    @comands = obj['states']
    @state_count = obj['total']
    @current_state = 0
  end

  def execute_comand(cmd)
    case cmd[0]
    when 'set_text'
      set_text(cmd[1], cmd[2])
    when 'remove'
      remove_element(cmd[1])
    when 'copy'
      if cmd.size == 4
        cmd[1].times do
          copy_element(cmd[2], cmd[3])
        end
      else
        copy_element(cmd[1], cmd[2])
      end
    when 'el_to_link'
      el_to_link(cmd[1])
    when 'refresh'
      refresh_page
    end
  end

  def set_text(selector, text)
    # p 'set_text selector:' + selector + 'text' + text
    @browser.execute_script("#{i_html(selector)} = '#{text}'")
  end

  def replace_texts(selector, text)
    # @browser.execute_script("document.querySelectorAll('#{selector}').forEach(item => { item.innerHTML = '#{text}'})")
  end

  def remove_element(selector)
    # p 'remove ' + selector
    @browser.execute_script("document.querySelector('#{selector}').remove()")
  end

  def copy_element(el_to_copy, paste_inside)
    @browser.execute_script("#{i_html(paste_inside)} += #{o_html(el_to_copy)}")
  end

  def refresh_page
    # p 'refresh page'
    @browser.refresh
  end

  # Dirty implementation of the element replacing method
  def el_to_link(selector)
    link = '<a style = \"text-decoration: underline\" class=\"link\"> Link instead of button </a>'
    @browser.execute_script("#{o_html(selector)} = '#{link}' ")
  end

  def add_style(selector, style)
    change_attr(:style, selector, style)
  end

  def replace_class(selector, klass)
    change_attr(:class, selector, klass)
  end

  def add_class(selector, klass)
    str = [@browser.element(css: selector).attribute_value('class'), klass].join(' ')
    change_attr(:class, selector, str)
  end

  def add_el_to_begin(el_for_insert, parent_node)
    @browser.execute_script(" #{i_html(parent_node)} =
                              #{o_html(el_for_insert)} + #{i_html(parent_node)}
                           ")
  end

  # return innerHTML of the element
  def i_html(selector)
    "document.querySelector('#{selector}').innerHTML"
  end

  # return outerHTML of the element
  def o_html(selector)
    "document.querySelector('#{selector}').outerHTML"
  end

  def change_attr(atr, sel, str)
    @browser.execute_script("document.querySelector('#{sel}')
                                     .setAttribute(\"#{atr}\",\"#{str}\")")
  end

  def parse_filename(str)
    str.split('/')[1] + '_' + /[0-9]/.match(str).to_s + '.yml'
  end
end
