
public class PercolationStats {
    private double []results;
    private int N;
    private int T;

    public PercolationStats(int N, int T)     // perform T independent experiments on an N-by-N grid
    {
        if ( N <= 0 || T <= 0) throw new IllegalArgumentException("Wrong argument");
        this.N = N;
        this.T = T;
        results = new double[T];
        for (int count = 0; count < T; count++)
        {
            Percolation p = new Percolation(N);
            //////Start
            int openedSites = 0;	     
            int [] gridPositions = new int[N*N];
            int closedPositions = N*N;

            // Fill the array with index values
            for (int i = 0; i < N*N; i++)
                gridPositions[i] = i;

            while (!p.percolates())
            {      
                if (0 == closedPositions)
                {
                    break; 
                    //TODO: throw exception 
                }

                // 1  Generate a random value from 0 to sizeof the array -1 and use the value at that index position.
                int randPos = StdRandom.uniform(closedPositions);
                int i = 1 + gridPositions[randPos] % N;
                int j = 1 + (gridPositions[randPos] - i + 1) / N;

                // 2. Reduce the array size by 1.
                closedPositions--;

                // 3. Take the value from the end of the array and move it into the position you've just used. 
                gridPositions[randPos] = gridPositions[closedPositions];


                p.open(i, j);
                openedSites++;

                //StdOut.printf("rE: attemted# %1d  %1d %1d was opened %b percolates %b closedPositions %1d openedSites %1d\n", 
                //count,i, j, p.isOpen(i, j), p.percolates(), closedPositions, openedSites);
            }
            //store resutls
            results[count]  = openedSites / N;


        }
    }
    public double mean()                      // sample mean of percolation threshold
    {
        double val = 0;
        for (int count = 0; count < T; ++count)
            val += results[count];
        val = val/T; //for debugging
        return val;
    }

    public double stddev()                    // sample standard deviation of percolation threshold
    {
        double val = 0;
        double percThreshold = this.mean();
        for (int count = 0; count < this.T; ++count)
            val += (results[count] -percThreshold)*(results[count] -percThreshold);
        val = val/(this.T-1);
        val = Math.sqrt(val);
        return val;

    }
    public double confidenceLo()              // low  endpoint of 95% confidence interval
    {
        double percThreshold = this.mean();
        double stdDev = this.stddev();
        double val = percThreshold - (1.96*stdDev)/Math.sqrt(this.T);
        return val;

    }
    public double confidenceHi()              // high endpoint of 95% confidence interval
    {
        double percThreshold = this.mean();
        double stdDev = this.stddev();
        double val = percThreshold + (1.96*stdDev)/Math.sqrt(this.T);
        return val;
    }
    public static void main(String[] args)    // test client (described below)
    {
        int N = Integer.parseInt(args[0]);
        int T = Integer.parseInt(args[1]);

        PercolationStats ps = new PercolationStats(N, T);
        double mean = ps.mean();
        double stdDev = ps.stddev();
        double hi = ps.confidenceHi();
        double lo = ps.confidenceLo();
        StdOut.printf("mean                        =%1f ", mean);
        StdOut.printf("stddev                      =%1f ", stdDev);
        StdOut.printf("95percent confidence interval     =%1f, %1f", hi,lo);
        
    }
}
