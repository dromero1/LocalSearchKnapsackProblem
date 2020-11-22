# LocalSearchKnapsackProblem

*A multi-start iterated local search for the multidimensional demand-constrained knapsack problem*

The knapsack problem has received considerable critical attention in the realms of combinatorial optimization as it provides the foundations for optimal discrete decision-making with limited resources. In this paper, a variant of the preceding problem, known as *multidimensional demand-constrained knapsack problem*, is examined by considering a set of resources with minimum use policies. In particular, this study proposes two local-search-based approaches, a 3-neighborhood *variable neighborhood descent* (VND) and a *multi-start iterated local search* (MS-ILS), to approximate the Pareto Front of 20 mid-size randomly generated instances. The developed meta-heuristics deliver promising results as significant improvements in the quality and diversity of the obtained non-dominated solutions are revealed with respect to unenhanced schemes. Experiments show a notable upgrade by applying local search mechanisms. However, results are inconclusive whether the proposed perturbation component is favorable.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Usage

Run the console program as follows:

```
main
```

The program prompts the results.

```
Instance 1 - Statistics
Number of solutions: 119
Number of feasible solutions: 119
Number of pareto-optimal solutions: 38
Number of feasible solutions in pareto front: 38
Method C (time = 0.014, sol. 1, psol. = 1, pfea. = 1, md2ub = 0.79, I1 = 0.00, I2 = 0.00)
Method G-0.05 (time = 3.054, sol. 3740, psol. = 1, pfea. = 1, md2ub = 0.76, I1 = 0.00, I2 = 0.00)
Method G-0.15 (time = 3.006, sol. 3952, psol. = 1, pfea. = 1, md2ub = 0.75, I1 = 0.00, I2 = 0.00)
Method G-0.25 (time = 3.025, sol. 3052, psol. = 9, pfea. = 9, md2ub = 0.75, I1 = 0.00, I2 = 0.00)
Method G-VND-0.05 (time = 3.014, sol. 23, psol. = 15, pfea. = 15, md2ub = 0.70, I1 = 0.11, I2 = 0.27)
Method G-VND-0.15 (time = 3.006, sol. 38, psol. = 26, pfea. = 26, md2ub = 0.70, I1 = 0.32, I2 = 0.46)
Method G-VND-0.25 (time = 3.034, sol. 10, psol. = 10, pfea. = 10, md2ub = 0.70, I1 = 0.24, I2 = 0.90)
Method MS-ILS-G-0.05 (time = 3.037, sol. 6, psol. = 6, pfea. = 6, md2ub = 0.71, I1 = 0.08, I2 = 0.50)
Method MS-ILS-G-0.15 (time = 3.021, sol. 40, psol. = 39, pfea. = 39, md2ub = 0.71, I1 = 0.05, I2 = 0.05)
Method MS-ILS-G-0.25 (time = 3.052, sol. 22, psol. = 20, pfea. = 20, md2ub = 0.70, I1 = 0.37, I2 = 0.70)
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
