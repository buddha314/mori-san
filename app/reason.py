from flask import Blueprint, request
import scallopy
import random
import string
# Create basic reason blueprint

reason = Blueprint('reason', __name__)

# Define a route for the blueprint
# add POST to the route to accept data
@reason.route('/reason', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # pull the alarm_whiteboard from the request json
        alarm_whiteboard = request.get_json()["alarm_whiteboard"]
        output = process_whiteboard(alarm_whiteboard)
    else:
        return "This is the reason blueprint"
    return output

def process_whiteboard(alarm_whiteboard):
    # Intialize the scallopy context
    ctx = scallopy.ScallopContext(provenance="topkproofs")

    # Grab the relations
    all_relations = [x for x in alarm_whiteboard['nodes'] if (x['logic_class']) =='relation']
    for rel in all_relations:
        ctx.add_relation("{r}".format(r=rel['id']), str)
        inbound_edges = [x["from_node"] for x in alarm_whiteboard['edges'] if x['to_node'] == rel['id']]
        #print(inbound_edges)
        rel_facts = [(float(x["data"]["probability"]), (x["data"]["fact"],))  for x in alarm_whiteboard['nodes'] if x['id'] in inbound_edges]
        #print("{r}".format(r=rel['id']))
        #print(rel_facts)
        ctx.add_facts("{r}".format(r=rel['id']), rel_facts)
    
    all_rules = [x for x in alarm_whiteboard['nodes'] if (x['logic_class']).startswith('rule')]
    #print(all_rules)
    rule_strings = []
    for rule in all_rules:
        print(rule)
        inbound_edges = [(ind, x["from_node"]) for ind, x in 
                         enumerate(alarm_whiteboard['edges']) 
                         if x['to_node'] == rule['id']]
        print(inbound_edges)
        if rule['logic_class'] == 'rule_and':
            rule_str = "{r}() = {rels}".format(
                r=rule['id'],
                rels = ", ".join(x[1]+"({i})".format(i=string.ascii_lowercase[x[0]]) for x in inbound_edges)
                )
            print(rule_str)
            rule_strings.append(rule_str)
            ctx.add_rule(rule_str)
    
    ctx.run()
    rules = []
    for i, rule in enumerate(all_rules):
        j = {}
        j["node_id"] = rule['id']
        j["rule_string"] = rule_strings[i] 
        conclusions = []
        k = 0
        for prob, tup in ctx.relation(rule['id']):
            x = {}
            x['id'] = k
            x['probability'] = prob
            x['tuples'] = tup
            conclusions.append(x)
            k += 1
            print(prob, tup)
        j["conclusions"] = conclusions
        rules.append(j)
    
    # Format output
    output = {}
    output["relations"] = all_relations
    output["rules"] = rules
    return output

