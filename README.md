
# High-Speed IP Routing Lookup

This project implements high-speed IP routing table lookup algorithms in Swift, inspired by techniques described in the paper "Fast and Scalable Internet Routing Lookups" (Waldvogel et al., 1997).

## Features

- **Efficient IP Routing Table Lookup:** Uses optimized data structures and sorting algorithms for fast IP prefix matching.
- **Bucket Sort Implementation:** Custom bucket sort for organizing IP prefixes by length.
- **Prefix Table Data Structures:** Classes for IP addresses and prefix table cells.
- **Sample Routing Tables:** Example data files (`table1.txt`, `table2.txt`, `table3.txt`) for testing and benchmarking.

## File Structure

- `src/`
	- `main.swift`: Main logic for routing lookup and sorting.
	- `IP.swift`: Defines the IP address class and related properties.
	- `PrefixTableCell.swift`: Defines the prefix table cell class.
- `data/`
	- `table1.txt`, `table2.txt`, `table3.txt`: Sample routing tables.
- `paper/`
	- `waldvogel1997.pdf`: Reference paper for the implemented algorithms.

## Usage

1. Place your routing table data in the `data/` directory.
2. Run the Swift code in `src/main.swift` to perform lookups and sorting.
3. Modify or extend the classes in `src/` to experiment with different algorithms or data structures.

## Reference

- Waldvogel, M., et al. "Fast and Scalable Internet Routing Lookups." SIGCOMM 1997. ([PDF in `paper/`](paper/waldvogel1997.pdf))
