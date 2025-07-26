let t = Parser.parse () in
print_string (Tree.to_string t ^ "\n\n");
Tree.pretty_print_tree t
