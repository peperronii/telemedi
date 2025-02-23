package main

import ui "webui"

main :: proc() {
    my_window: uint = ui.new_window()
    ui.show(my_window, "<html> <script src=\"webui.js\"></script> Thanks for using WebUI! </html>")
    ui.wait()
}