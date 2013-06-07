package edu.uw.cs.biglearn.shotgun;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import edu.uw.cs.biglearn.util.MatUtil;

public class Shooting {
	
	/* Dimension of X */
	int n, p;
	
	/* Regularization parameter */
	double lambda;
	
	/* Stores the positive part of w */
	float[] wplus;
	
	/* Stores the negative part of w */
	float[] wminus;
	
	/* Stores the product of Xw */
	float[] xw;
	
	/* The transpose of the design matrix X */
	final float[][] XTrans;
	
	/* The response vector Y. */
	final float[] Y;
	
	/* Stores the current parameter. */
	float[] w;
	
	/* Stores the stale parameter. */
	float[] oldw;
	
	static final int NUM_CORES = Runtime.getRuntime().availableProcessors();
	
	/**
	 * Constructor
	 * @param XTrans
	 * @param Y
	 * @param lambda
	 */
	public Shooting(float[][] XTrans, float[] Y, double lambda) {
		this.XTrans = XTrans;
		this.Y = Y;
		p = XTrans.length;
		n = XTrans[0].length;
		this.lambda = lambda;
		
		/**
		 * Initialize the parameter
		 */
		wplus = new float[p];
		wminus = new float[p];
		xw = new float[n];
		w = new float[p];
		oldw = new float[p];
	}
	
	/**
	 * Perform coordinate descent at K random chosen coordinates;
	 * @param j
	 */
	public void shoot(int K) {
		Random r = new Random();
		for (int i = 0; i < K; i++) {
			int j = r.nextInt(2*p);
			if (j < p) {
				float[] xj = XTrans[j];
				float gj = MatUtil.dot(xj, MatUtil.minus(xw, Y))/n;			
				float delta = (float) Math.max(-wplus[j], -gj - lambda);
				wplus[j] += delta;
				float[] xwdelta = MatUtil.scale(xj, delta);
				MatUtil.plusequal(xw, xwdelta);
			} else {
				j = j-p;
				float[] xj = XTrans[j];
				float gj =  -MatUtil.dot(xj, MatUtil.minus(xw, Y))/n;			
				float delta = (float) Math.max(-wminus[j], -gj - lambda);
				wminus[j] += delta;
				float[] xwdelta = MatUtil.scale(xj, -delta);
				MatUtil.plusequal(xw, xwdelta);
			}
		}
	}
	
	/**
	 * Run Sequential SCD until convergence or exceeding maxiter.
	 */
	public float[] scd (int maxiter) {
		int iter = 0;
		while (iter  < maxiter) {
			shoot(p);
			iter += p;		
			if (iter % p == 0) {
				w = MatUtil.minus(wplus, wminus);
				float[] wdelta = MatUtil.minus(w, oldw);
				float delta = MatUtil.l2(wdelta);
				if (delta < 1e-5) {
					break;
				}
				oldw = w.clone();
			}
		}
		return w;
	}
	
	/**
	 * Run Shotgun parallel SCD until convergence or exceeding maxiter.
	 */
	public float[] shotgun (int maxiter) {
		final int batchsize = p;
		int iter = 0;
		
		while(iter < maxiter) {
			ExecutorService threadpool = Executors.newFixedThreadPool(NUM_CORES);
			// submit batchsize coordinate descent jobs in parallel.
			for (int i = 0; i < NUM_CORES; i++) {
				threadpool.submit(new Runnable() {
					public void run() {
						shoot(batchsize / NUM_CORES);
					}
				});
			}
			iter += batchsize;
			
			// Wait for jobs to terminate and check the result
			threadpool.shutdown();
			while (!threadpool.isTerminated()) {
				try {
					threadpool.awaitTermination(20, TimeUnit.SECONDS);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			
			// check whether the result has converged.
			w = MatUtil.minus(wplus, wminus);
			float[] wdelta = MatUtil.minus(w, oldw);
			float delta = MatUtil.l2(wdelta);
			if (delta < 1e-5) {
				break;
			}
			oldw = w.clone();
		}
		return w;
	}
}
