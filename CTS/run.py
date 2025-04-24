import os
import random
import time
from collections import defaultdict
from functools import cache
import clingo
import argparse

def get_encoding():
    with open(os.path.join('CTS', 'framework_encoding.lp'), 'r') as encoding:
        return encoding.read()


def get_input(file_path):
    with open(file_path, 'r') as file:
        return file.read()


@cache
def run_timeslot(ms_result, day):
    if not ms_result:
        return False
    ctl2 = clingo.Control(['1', '--opt-mode=optN'])
    ctl2.add(get_encoding())
    ctl2.add("ms_result", [], '. '.join([str(x) for x in ms_result]) + '. ' + input)
    ctl2.ground([("timeslot", []), ("ms_result", [])])
    unsatisfiable = True
    def on_model(m):
        res[day]['cost'] = m.cost
        res[day]['model'] = m.symbols(shown=True)
        res[day]['optimality_proven'] = m.optimality_proven
        nonlocal unsatisfiable
        unsatisfiable = False
    with ctl2.solve(on_model=on_model, async_=True) as handle:
        handle.wait(30)
        handle.cancel()
    return unsatisfiable


def parse_result(arr):
    res = defaultdict(list)
    for atom in arr:
        if atom.name in ['x']:
            res[atom.arguments[1].number].append(atom)
        elif atom.name in ['bed', 'chair']:
            res[atom.arguments[2].number].append(atom)
    return res

parser = argparse.ArgumentParser()
parser.add_argument('input_file')
args = parser.parse_args()
input = get_input(args.input_file)
start_time = time.time()
solving  = True
ctl = clingo.Control(['1', '--opt-mode=optN'])
ctl.add(input)
ctl.add(get_encoding())
res = defaultdict(dict)
ctl.ground([("base", [])])
nogood = set()
while solving:
    with ctl.solve(yield_=True) as handle:
        for m in handle:
            if m.optimality_proven:
                res['master']['cost'] = m.cost
                res['master']['model'] = m.symbols(shown=True)
        if not handle.get().satisfiable:
            print("UNSAT")
            exit(0)
    unsat = False
    parts = []
    dict = parse_result(res['master']['model'])
    for d in dict.keys():
        unsat_subproblem = run_timeslot(tuple(dict[d]), d)
        if unsat_subproblem:
            unsat = True
            # create no goods
            rand_id = random.randint(1, 100000)
            while rand_id in nogood:
                rand_id = random.randint(1, 100000)
            nogood.add(rand_id)
            for s in dict[d]:
                if s.name == 'bed':
                    parts.append((f"nogood", [s.arguments[0], s.arguments[1], clingo.Number(rand_id), clingo.Number(1), clingo.Number(0)]))
                elif s.name == 'chair':
                    parts.append((f"nogood", [s.arguments[0], s.arguments[1], clingo.Number(rand_id), clingo.Number(0), clingo.Number(1)]))
            break
    ctl.ground(parts)
    if not unsat:
        solving = False
execution_time = time.time() - start_time

print("Master model:\n")
print('. '.join(map(str, res['master']['model'])) + '.')
print("Master cost:", res['master']['cost'])
print('\n')
for subproblem in res.keys():
    if subproblem != 'master':
        print(f"Day {subproblem} model:\n")
        print('. '.join(map(str, res[subproblem]['model'])) + '.')
        print("Cost:", res[subproblem]['cost'])
        print("Optimality proven:", res[subproblem]['optimality_proven'])
        print('\n')


print("Execution time: %.4f seconds" % execution_time)
