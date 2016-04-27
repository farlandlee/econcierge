// useful functional programming functions
// chaining them means using reduce...
// someday, might be worth just extending
// the ember array prototype?

/**
   ['a', 'a', 'b'].reduce(toSet, [])
   #=> ['a', 'b']
*/
export const toSet = (set, value) => {
  if (!set.contains(value)) {
    set.pushObject(value);
  }
  return set;
};

/**
   [[1], [2, 3]].reduce(flatten, [])
   #=> [1, 2, 3]
*/
export const flatten = (flattened, arr) => {
  arr.forEach(x => flattened.pushObject(x));
  return flattened;
};
