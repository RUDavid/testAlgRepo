import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class Percolation {
	boolean[][] mGrid;
	int N;
	WeightedQuickUnionUF wquUF;

	public Percolation(int N) // create N-by-N grid, with all sites blocked
	{
		this.N = N; // set grid size
		// Initialize grid, false -
		mGrid = new boolean[N][N];
		for (int i = 0; i <= N; ++i) {
			for (int j = 0; j <= N; ++j)
				mGrid[i][j] = false;
		}
		wquUF = new WeightedQuickUnionUF(N*N);
		// [i,j] maps to: (i-1)N + j
	}

	public void open(int i, int j) // open site (row i, column j) if it is not
									// open already
	{
		if (i <= 0 || i > N) throw new IndexOutOfBoundsException("row index i out of bounds");
		if (j <= 0 || j > N) throw new IndexOutOfBoundsException("column index j out of bounds");
		mGrid[i][j] = true;
	}

	public boolean isOpen(int i, int j) // is site (row i, column j) open?
	{
		if (i <= 0 || i > N) throw new IndexOutOfBoundsException("row index i out of bounds");
		if (j <= 0 || j > N) throw new IndexOutOfBoundsException("column index j out of bounds");
		return mGrid[i][j];
	}

	public boolean isFull(int i, int j) // is site (row i, column j) full?
	{
		if (i <= 0 || i > N) throw new IndexOutOfBoundsException("row index i out of bounds");
		if (j <= 0 || j > N) throw new IndexOutOfBoundsException("column index j out of bounds");
		for(int k = 1; k <= N; ++k) // check first row(top cells)
		{
			if(mGrid[1][k]) // if cell is open 
			{
				if(wquUF.connected( getArrayIndex(1,k), getArrayIndex(i,j)) )
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
		for(int i = 1; i <= N; ++i) //  first row(top cells)
		{
			if(mGrid[0][i]) // if cell is open
			{
				for(int j = 1; j <= N; ++j) // last row(bottom cells)
				{
					if(mGrid[N][j]) // if cell is open 
					{
						if(wquUF.connected( getArrayIndex(0,i), getArrayIndex(N,j)) )
						{
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	private int getArrayIndex(int i, int j ) { return N*(i-1)+j;}
	
	public static void main(String[] args) // test client (optional)
	{
		System.out.println("Percolation, main");
	}
}