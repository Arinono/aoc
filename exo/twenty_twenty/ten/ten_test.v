module ten

fn test_mul_diffs() {
	input := '28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3'

	mut adapters := parse_input(input)

	diff1, _, diff3 := adapters.get_diffs()

	assert diff1 == 21
	assert diff3 == 10
}

fn test_find_max_arrangements() {
	input := '16
10
15
5
1
11
7
19
6
12
4'

	mut adapters := parse_input(input)

	arrangements := adapters.find_max_arrangements()

	assert arrangements == 8
}

fn test_find_max_arrangements_many() {
	input := '28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3'

	mut adapters := parse_input(input)

	arrangements := adapters.find_max_arrangements()

	assert arrangements == 10976
}
