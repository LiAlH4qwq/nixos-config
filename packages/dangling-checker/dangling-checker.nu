def check-dangling [allows: record<dirs: list<list<string>>, files: list<list<string>>>, item: list<string>]: nothing -> record<danglings: list<list<string>>, warnings: list<record<msg: string, path: list<string>>>> {
    let item_abs: list<string> = $item | path join | path expand | path split
    if $item_abs == [] {
        error make 'Item path to check cannot be empty!'
    }
    let item_path: string = $item_abs | path join
    let item_type: string = ls -D $item_path | get 0 | get type
    let allow_dirs: list<list<string>> = $allows.dirs | par-each {path join | path expand | path split}
    let allow_files: list<list<string>> = $allows.files | par-each {path join | path expand | path split}
    match $item_type {
        dir => {
            if $item_abs in $allow_dirs {
                return {
                    danglings: []
                    warnings: []
                }
            }
            if $item_abs in $allow_files {
                return {
                    danglings: []
                    warnings: [
                        {
                            msg: "Type mismatch, wanted: dir, got: file!"
                            path: $item_abs
                        }
                    ]
                }
            }
            let allow_alls = $allow_dirs ++ $allow_files
            let not_prefix_of_any = $allow_alls | par-each {|allow|
                $item_abs | is-prefix-of $allow
            } | any {} | not $in
            if $not_prefix_of_any {
                return {
                    danglings: [$item_abs]
                    warnings: []
                }
            }
            let childs: list<list<string>> = ls $item_path | get name | par-each {|name| $name | path expand | path split}
            $childs | par-each {|child| check-dangling $allows $child} | reduce --fold {danglings: [], warnings: []} {|cur, acc|
                {
                    danglings: ($acc.danglings ++ $cur.danglings)
                    warnings: ($acc.warnings ++ $cur.warnings)
                }
            }
        }
        file => {
            if $item_abs in $allow_files {
                return {
                    danglings: []
                    warnings: []
                }
            }
            if $item_abs in $allow_dirs {
                return {
                    danglings: []
                    warnings: [
                        {
                            msg: "Type mismatch, wanted: file, got: dir!"
                            path: $item_abs
                        }
                    ]
                }
            }
            {
                danglings: [$item_abs]
                warnings: []
            }
        }
        _ => { error make "Item type to check must be dir or file!" }
    }
}
def is-prefix-of [target: list<any>]: list<any> -> bool { let src: list = $in
let src_length = $src | length
let target_length = $target | length
if $src_length > $target_length {
    return false
}
if $src_length == $target_length {
    return ($src == $target)
}
let target_init: list = $target | take $src_length
$src == $target_init }

def main [...args]: nothing -> string {
    let allows: record<dirs: list<list<string>>, files: list<list<string>>> = $args | get 0 | open -r $in | from json
    let item: list<string> = $args | get 1 | path expand | path split
    let result = check-dangling $allows $item
    match $result {
        {danglings: [], warnings: []} => {
            'No danglings or warnings.' | print
            exit 0
        }
        {warnings:[], danglings: $danglings} => {
            'No warnings.' | print
            'Danglings:' | print
            $danglings | par-each {|dangling| $dangling | path join} | sort | str join "\n" | print
            exit 1
        }
        {danglings:[], warnings: $warnings} => {
            'No danglings.' | print
            'Warnings:' | print
            $warnings | sort-by path | par-each {|warning| $"($warning.path)\n($warning.msg)"} | str join "\n\n" | print
            exit 2
        }
        {danglings:$danglings, warnings: $warnings} => {
            'Danglings:' | print
            $danglings | par-each {|dangling| $dangling | path join} | sort | str join "\n" | print
            'Warnings:' | print
            $warnings | sort-by path | par-each {|warning| $"($warning.path)\n($warning.msg)"} | str join "\n\n" | print
            exit 3
        }
    } 
}
