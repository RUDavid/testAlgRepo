
public class Percolation {

    private boolean[][] mGrid;
    private int N;
    private WeightedQuickUnionUF wquUF;

    public Percolation(int N){ // create N-by-N grid, with all sites blocked

        if ( N <= 0 ) throw new IllegalArgumentException("Wrong argument");
        this.N = N; // set grid size
        // Initialize grid, false -
        mGrid = new boolean[N+1][N+1];
        for (int i = 1; i <= N; ++i) {
            for (int j = 1; j <= N; ++j)
                mGrid[i][j] = false;
        }
        wquUF = new WeightedQuickUnionUF(N*N);
        // [i,j] maps to: (i-1)N + j - 1		
    }

    public void open(int i, int j) // open site (row i, column j) if it is not
    // open already
    {
        if (i <= 0 || i > N) throw new IndexOutOfBoundsException("row index i out of bounds");
        if (j <= 0 || j > N) throw new IndexOutOfBoundsException("column index j out of bounds");
        mGrid[i][j] = true;
        int [] dRow = { -1, 0, +1, 0 };
        int [] dCol = { 0, -1, 0, +1 };
        for (int k = 0; k < 4; k++) {
            int nextRow = i + dRow[k];
            int nextCol = j + dCol[k];
            // check the index correctnes, and is given site open? then connect them
            if (nextRow >= 1 && nextCol >= 1 && nextRow <= N  && nextCol <= N && mGrid[nextRow][nextCol]){ 
                wquUF.union( getArrayIndex( i, j), getArrayIndex( nextRow, nextCol));

            }
        }
    }

    public boolean isOpen(int i, int j) // is site (row i, column j) open?
    {
        if (i <= 0 || i > N) throw new IndexOutOfBoundsException("row index i out of bounds");
        if (j <= 0 || j > N) throw new IndexOutOfBoundsException("column index j out of bounds");
        return mGrid[i][j];
    }

    public boolean isFull( int i, int j ) // is site (row i, column j) full?
    {
        if (i <= 0 || i > N ) throw new IndexOutOfBoundsException("row index i out of bounds");
        if (j <= 0 || j > N ) throw new IndexOutOfBoundsException("column index j out of bounds");
        for (int k = 1; k <= N; ++k) // check first row(top cells)
        {
            if ( mGrid[1][k] ) // if cell is open 
            {
                if (wquUF.connected( getArrayIndex( 1, k ), getArrayIndex( i, j )))
                {
                    return true;
                }
            }
        }
        // return false if (i,j) is not connected to the any of open cell on top
        return false;
    }

    public boolean percolates() // does the system percolate?
    {
        for (int i = 1; i <= N; ++i) //  first row(top cells)
        {
            if (mGrid[1][i]) // if cell is open
            {
                for (int j = 1; j <= N; ++j) // last row(bottom cells)
                {
                    if (mGrid[N][j]) // if cell is open 
                    {
                        if (wquUF.connected( getArrayIndex( 1, i), getArrayIndex( N, j)) )
                        {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    private int getArrayIndex(int i, int j ) { return N * ( i - 1 ) + j - 1; } 

    public static void main(String[] args) // test client (optional)
    {
        int N = 20;
        Percolation p = new Percolation ( N );
        //////Start
        int openedSites = 0;	     
        int [] gridPositions = new int[N * N];
        int closedPositions = N*N;

        // Fill the array with index values
        for (int i = 0; i < N * N; i++)
            gridPositions[i] = i;

        while (!p.percolates())
        {      
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

            StdOut.printf("rE: %1d %1d was opened %b percolates %b closedPositions %1d openedSites %1d\n", 
                    i, j, p.isOpen(i, j), p.percolates(), closedPositions, openedSites);
        }
        //////End
        System.out.println("Percolation, main");
    }
}