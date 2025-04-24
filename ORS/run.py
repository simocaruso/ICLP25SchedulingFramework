import os
import random
import time
from collections import defaultdict
from functools import cache
import clingo
import argparse

# CONFIG
# -------------
MASTER_TIMEOUT = 60
GLOBAL_TIMEOUT = 300
# -------------

def get_encoding():
    with open(os.path.join('ORS', 'framework_encoding.lp'), 'r') as encoding:
        return encoding.read()


def get_input(file_path):
    with open(file_path, 'r') as file:
        return file.read()


@cache
def run_timeslot(ms_result, day, shift):
    if not ms_result:
        return False
    ctl2 = clingo.Control(['1', '--opt-mode=optN'])
    ctl2.add(get_encoding())
    ctl2.add("ms_result", [], '. '.join([str(x) for x in ms_result]) + '. ' + input)
    ctl2.ground([("sub", []), ("ms_result", [])])
    unsatisfiable = True
    with ctl2.solve(yield_=True) as handle:
        for m in handle:
            res[day][shift]['model'] = m.symbols(shown=True)
            unsatisfiable = False
    return unsatisfiable


def parse_result(arr):
    res = defaultdict(lambda: defaultdict(list))
    for atom in arr:
        if atom.name in ['x']:
            res[atom.arguments[4].number][atom.arguments[3].number].append(atom)
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
res = defaultdict(lambda: defaultdict(dict))
ctl.ground([("base", [])])
nogood = set()
while solving:
    def on_model(m):
        res['master']['cost'] = m.cost
        res['master']['model'] = m.symbols(shown=True)
        res['master']['opt'] = m.optimality_proven
    with ctl.solve(on_model=on_model, async_=True) as handle:
        handle.wait(min(GLOBAL_TIMEOUT - (time.time()-start_time), MASTER_TIMEOUT))
        handle.cancel()
    if not res['master']['model']:
        print("No models found for master problem before timeout")
        exit(0)
    unsat = False
    parts = []
    dict_day_shift = parse_result(res['master']['model'])
    for d in dict_day_shift.keys():
        for shift in dict_day_shift[d].keys():
            unsat_subproblem = run_timeslot(tuple(dict_day_shift[d][shift]), d, shift)
            if unsat_subproblem:
                unsat = True
                # create no goods
                rand_id = random.randint(1, 100000)
                while rand_id in nogood:
                    rand_id = random.randint(1, 100000)
                nogood.add(rand_id)
                for s in dict_day_shift[d][shift]:
                    if s.name == 'x':
                        parts.append((f"nogood", [s.arguments[0], s.arguments[2], s.arguments[3], s.arguments[4], clingo.Number(rand_id)]))    
    ctl.ground(parts)
    if not unsat or time.time() - start_time >= GLOBAL_TIMEOUT:
        solving = False
execution_time = time.time() - start_time


print("Master model:\n")
print('. '.join(map(str, res['master']['model'])) + '.')
print("Master cost:", res['master']['cost'], "OPTIMUM FOUND" if res['master']['opt'] else '')
print('\n')
for subproblem in res.keys():
    if subproblem != 'master':
        for shift in res[subproblem].keys():
            print(f"Day {subproblem}, shift {shift} model:\n")
            print('. '.join(map(str, res[subproblem][shift]['model'])) + '.')
            print('\n')


print("Execution time: %.4f seconds" % execution_time)
