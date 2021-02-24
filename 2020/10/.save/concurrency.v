// Was working before I introduced memoisation
// Fails with a nice segfault
// Is it the locks ? a wrong map (memo) access ? or smth else ?

// after some debug, it's everytime I try to access the map
// the condition on map len in the 1st lock on delayed the issue
// to the 2nd lock at the end of the function
// Basically I can't assign to `arrangements.memo[i]`

struct Arrangements {
mut:
	tot u64 = u64(0)
	memo map[u64]u64 = map[u64]u64{}
}

fn (shared arrangements Arrangements) recurse(arr []Adapter, i u64, mut wg sync.WaitGroup) {
	lock arrangements {
		if arrangements.memo.len > 0 && i in arrangements.memo {
			arrangements.tot += arrangements.memo[i]
			wg.done()
			return
		}
	}

	if i == arr.len - 1 {
		lock arrangements {
			arrangements.tot++
		}
		wg.done()
		return 
	}

	if i + 1 < arr.len && arr[i + 1] - arr[i] <= 3 {
		wg.add(1)
		go arrangements.recurse(arr, i + u64(1), mut wg)
	}
	if i + 2 < arr.len && arr[i + 2] - arr[i] <= 3 {
		wg.add(1)
		go arrangements.recurse(arr, i + u64(2), mut wg)
	}
	if i + 3 < arr.len && arr[i + 3] - arr[i] <= 3 {
		wg.add(1)
		go arrangements.recurse(arr, i + u64(3), mut wg)
	}

	lock arrangements {
		arrangements.memo[i] = arrangements.tot
	}
	wg.done()
	return
}

fn (mut ac AdapterChain) find_max_arrangements() u64 {
	mut wg := sync.new_waitgroup()
	mut res := u64(0)
	shared arrangements := Arrangements {}
	
	wg.add(1)
	go arrangements.recurse(ac.ordered_adapters, 0, mut wg)
	wg.wait()

	rlock arrangements {
		res = arrangements.tot
	}

	return res
}
