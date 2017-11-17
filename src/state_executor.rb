class Executor
    def initialize (browser,comands)
        @browser = browser
        @comands = comands
        @state = 0
        
    end

    def comand
        comand[state].each do |current_comand| 
            execute_comand(current_comand)
        end
    end

    def execute_comand(cmd)
        case cmd[0] do
        when 'set_text'
            replace_text(cmd[1], cmd[2])
        end
    end

    def replace_text(selector, text)
        @browser.execute_script("document.querySelector('#{selector}').innerHTML = '#{text}'")
    end
      
    def replace_texts(selector, text)
        @browser.execute_script("document.querySelectorAll('#{selector}').forEach(item => { item.innerHTML = '#{text}'})")
    end
      
    def remove_element(selector)
        @browser.execute_script("document.querySelector('#{selector}').remove()")
    end
    
    def copy_element(el_to_copy, paste_inside)
        out = @browser.execute_script("return document.querySelector('#{el_to_copy}').outerHTML")
        @browser.execute_script("document.querySelector('#{paste_inside}').innerHTML += #{out}")
    end
    
    def refresh
        @browser.refresh
    end
end