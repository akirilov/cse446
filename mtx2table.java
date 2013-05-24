import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class mtx2table {

	public static void main(String[] args) {
		if( args.length != 1 ) {
			System.out.println("Usage: java mtx2table FILENAME");
		} else {
			String filename = args[0];
			try {
				@SuppressWarnings("resource")
				BufferedReader fileIn = new BufferedReader(new FileReader(filename));
				fileIn.readLine();
				fileIn.readLine();
				String lineTwo = fileIn.readLine();
				String[] tokens = lineTwo.split("[ ]+");
				int[] dims = new int[2];
				for (int i = 0; i < tokens.length; i++) {
					try {
						dims[i] = Integer.parseInt(tokens[i]);
					}  catch (NumberFormatException f) {
								System.exit(1);
					}
				}
				int rows = dims[0];
				int cols = dims[1];
				System.out.println(rows + " rows and " + cols + " columns.");
				String[][] table = new String[rows][cols];
				System.out.println("table has " + table.length + " rows and " + table[0].length + " columns.");
				int rowNum = 0;
				int colNum = 0;
				for( String line = fileIn.readLine(); line != null; line = fileIn.readLine() ) {
					System.out.println("("+rowNum+","+colNum+")"+"= "+line);
					table[rowNum][colNum] = line;
					rowNum++;
					if( rowNum == rows) {
						System.out.println("rowNum = " + rowNum + " and rows-1=" + (rows-1) );
						colNum++;
						rowNum = 0;
					}
				}
				printTable(table);
			} catch (IOException e) {
				System.err
					.println("Error opening/reading/writing input or output file.");
				System.exit(1);
			}
		}
	}
	
	private static void printTable(String[][] table) {
		for( int i = 0; i < table.length; i++ ) {
			for( int j = 0; j < table[0].length; j++ ) {
				System.out.print(table[i][j] + " ");
			}
			System.out.println();
		}
	}
}
