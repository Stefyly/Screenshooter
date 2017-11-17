class Executor
  def initialize(browser, comands)
    @browser = browser
    @comands = comands
    @state = 0
  end

  def next_command
    if @comands[@state].first.is_a?(Array)
      @comands[@state].each do |current_comand|
        execute_comand(current_comand)
      end
    else
      execute_comand(@comands[@state])
    end
    @state += 1
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
    when 'refresh'
      refresh_page
    end
  end

  def set_text(selector, text)
    # p 'set_text selector:' + selector + 'text' + text
    @browser.execute_script("document.querySelector('#{selector}').innerHTML = '#{text}'")
  end

  def replace_texts(selector, text)
    # @browser.execute_script("document.querySelectorAll('#{selector}').forEach(item => { item.innerHTML = '#{text}'})")
  end

  def remove_element(selector)
    # p 'remove ' + selector
    @browser.execute_script("document.querySelector('#{selector}').remove()")
  end

  def copy_element(el_to_copy, paste_inside)
    # p 'copy_element el_to_copy: ' + el_to_copy + 'paste_inside: ' + paste_inside
    out = @browser.execute_script("return document.querySelector('#{el_to_copy}').outerHTML")
    @browser.execute_script("document.querySelector('#{paste_inside}').innerHTML += '#{out}'")
  end

  def refresh_page
    # p 'refresh page'
    @browser.refresh
  end
end