$env.config.menus ++= [{
    name: completion_menu
    only_buffer_difference: false
    marker: ""
    type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
        tab_traversal: vertical
    }
    style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
    }
}]