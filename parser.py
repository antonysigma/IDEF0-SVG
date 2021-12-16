from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor

grammar = Grammar(r"""
    expr        = (function / emptyline)*
    function    = block port+

    block       = quoted ws
    port        = type ws value ws

    type        = ~r"\w+"
    value       = ~r"\w[-:\w\. ]+\w"
    quoted      = ~'\[[^\[]+\]'
    ws          = ~"\s*"
    emptyline   = ws+
""")


def typeToAction(type):
    if type == 'in':
        return 'receives'
    elif type == 'res':
        return 'respects'
    elif type == 'out':
        return 'produces'
    elif type == 'ctrl':
        return 'requires'
    elif type == 'comp':
        return 'is compsed of'
    else:
        raise TypeError('Not part of IDEF0 keyword')


class IdefVisitor(NodeVisitor):

    def visit_expr(self, node, visited_children):
        """ Returns the overall output. """
        output = ''
        for child in visited_children:
            output += child[0]
        return output

    def visit_function(self, node, visited_children):
        """ Makes a dict of the section (as key) and the key/value pairs. """
        function_name, ports = visited_children

        output = ''
        for port in ports:
            action = typeToAction(port[0])
            output += f'{function_name} {action} {port[1]}\n'

        return output

    def visit_block(self, node, visited_children):
        """ Gets the section name. """
        quoted, *_ = visited_children
        return quoted.text[1:-1].title()

    def visit_port(self, node, visited_children):
        """ Gets each key/value pair, returns a tuple. """
        type, _, value, *_ = node.children
        return type.text, value.text

    def generic_visit(self, node, visited_children):
        """ The generic visit method. """
        return visited_children or node


if __name__ == '__main__':
    data = """[CookPizza]
    in Ingredients
    res CustomerOrder
    res Recipe
    ctrl Chef
    ctrl Kitchen
    out Pizza

[TakeOrder]
    out CustomerOrder
    res Menu
    ctrl WaitStaff
    in Pizza
    in HungryCustomer
    out SatisfiedCustomer
    out Mess
    """

    tree = grammar.parse(data)

    iv = IdefVisitor()
    output = iv.visit(tree)
    print(output)
