const roundToMultiple = (n, multiple) => {
  const value = Math.round(n)
  const difference = value % multiple
  return value - difference
}

export { roundToMultiple }
