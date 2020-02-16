import random

MAX_COST = 20
MIN_COST = 0


def randomise(test):
    for n1, connections in test:
        for i, connection in enumerate(connections):
            n2, cost = connections[i]
            cost = random.randint(MIN_COST, MAX_COST)
            connections[i] = (n2, cost)


def find_node(test, a):
    for i, node in enumerate(test):
        name = node[0]
        if name == a:
            return i
    return None


def travel_cost(test, a, b):
    node_index = find_node(test, a)

    if node_index is None:
        return None

    node = test[node_index]
    connections = node[1]
    connection_index = find_node(connections, b)

    if connection_index is None:
        return None

    connection = connections[connection_index]
    return connection[1]


test_paths = [
    ["a", "b", "c", "d", "a"],
    ["b", "a", "c", "d", "b"],
    ["c", "a", "b", "d", "c"],
    ["a", "c", "b", "d", "a"],
    ["b", "c", "a", "d", "b"],
    ["c", "b", "a", "d", "c"],
    ["c", "b", "d", "a", "c"],
    ["b", "c", "d", "a", "b"],
    ["d", "c", "b", "a", "d"],
    ["c", "d", "b", "a", "c"],
    ["b", "d", "c", "a", "b"],
    ["d", "b", "c", "a", "d"],
    ["d", "a", "c", "b", "d"],
    ["a", "d", "c", "b", "a"],
    ["c", "d", "a", "b", "c"],
    ["d", "c", "a", "b", "d"],
    ["a", "c", "d", "b", "a"],
    ["c", "a", "d", "b", "c"],
    ["b", "a", "d", "c", "b"],
    ["a", "b", "d", "c", "a"],
    ["d", "b", "a", "c", "d"],
    ["b", "d", "a", "c", "b"],
    ["a", "d", "b", "c", "a"],
    ["d", "a", "b", "c", "d"]
]

test_1 = [
    # 1
    ("a", [("b", 0), ("c", 0), ("d", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("a", 0), ("b", 0), ("d", 0)]),
    # 4
    ("d", [("a", 0), ("b", 0), ("c", 0)])
]

test_2 = [
    # 1
    ("a", [("b", 0), ("c", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("a", 0), ("b", 0), ("d", 0)]),
    # 4
    ("d", [("b", 0), ("c", 0)])
]

test_3 = [
    # 1
    ("a", [("b", 0), ("d", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("b", 0), ("d", 0)]),
    # 4
    ("d", [("a", 0), ("b", 0), ("c", 0)])
]

test_4 = [
    # 1
    ("a", [("b", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("b", 0), ("d", 0)]),
    # 4
    ("d", [("b", 0), ("c", 0)])
]

test_5 = [
    # 1
    ("a", [("b", 0)]),
    # 2
    ("b", [("a", 0), ("d", 0)]),
    # 3
    ("c", [("d", 0)]),
    # 4
    ("d", [("b", 0), ("c", 0)])
]

test_6 = [
    # 1
    ("a", [("b", 0)]),
    # 2
    ("b", [("a", 0), ("d", 0)]),
    # 3
    ("c", []),
    # 4
    ("d", [("a", 0), ("b", 0)])
]

test_7 = [
    # 1
    ("a", [("b", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("b", 0)]),
    # 4
    ("d", [("b", 0)])
]

test_8 = [
    # 1
    ("a", [("b", 0)]),
    # 2
    ("b", [("a", 0)]),
    # 3
    ("c", []),
    # 4
    ("d", [])
]

test_9 = [
    # 1
    ("a", []),
    # 2
    ("b", []),
    # 3
    ("c", []),
    # 4
    ("d", [])
]

test_10 = [
    # 1
    ("a", [("b", 0), ("d", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    ("c", [("d", 0)]),
    # 4
    ("d", [("a", 0), ("b", 0), ("c", 0)])
]

test_11 = [
    # 1
    ("a", [("b", 0), ("c", 0)]),
    # 2
    ("b", [("a", 0), ("c", 0), ("d", 0)]),
    # 3
    # 4
    ("d", [("b", 0), ("c", 0)])
]

test_12 = [
    # 1
    ("a", [("b", 0), ("c", 0), ("d", 0)]),
    # 2
    ("b", [("d", 0)]),
    # 3
    ("c", [("a", 0)]),
    # 4
    ("d", [("b", 0), ("c", 0)])
]

tests = [
    test_1,
    test_2,
    test_3,
    test_4,
    test_5,
    test_6,
    test_7,
    test_8,
    test_9,
    test_10,
    test_11,
    test_12
]


# Init
random.seed(0)
reports = []

for test in tests:
    randomise(test)

# Search
for test_index, test in enumerate(tests):
    report_entry = (test_index + 1, ["a", "b", "c", "d"], test, [])
    for path_index, path in enumerate(test_paths):
        path_valid = True
        cost_sum = 0
        for i in range(1, len(path)):
            cost = travel_cost(test, path[i - 1], path[i])
            if cost is not None:
                cost_sum += cost
            else:
                path_valid = False
                break
        if path_valid:
            report_entry[3].append((cost_sum, path))
    reports.append(report_entry)

# Print
with open("tests.txt", "w") as fp:
    for report in reports:
        print("testCase(", file=fp)
        print("    {},".format(report[0]), file=fp)
        print("    {},".format(report[1]).replace("'", ""), file=fp)
        print("    {},".format(report[2]).replace("'", ""), file=fp)
        print("    [", file=fp)
        for i, path in enumerate(report[3]):
            if i == len(report[3]) - 1:
                print("        {}".format(path).replace("'", ""), file=fp)
            else:
                print("        {},".format(path).replace("'", ""), file=fp)
        print("    ]", file=fp)
        print(").", file=fp)
        print("", file=fp)
