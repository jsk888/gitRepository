package com.qf.collection;

/**
 * �ݹ��㷨100���ڵĺ�
 * 
 * @author Administrator
 *
 */
public class DiGuiDemo {
	public static void main(String[] args) {
//		System.out.println(DiGuiDemo.add(100));
		System.out.println("�ܸ߶��ǣ�"+DiGuiDemo.add2(3));
	}

	public static int add(int num) {
		if (num == 1) {
			return 1;
		}
		return num + add(num - 1);
	}	
	
	//��100�׸߿������£�ÿ�ε���Ϊ��һ�ε�һ�룬numΪ��������
	public static double add2(int num){
		double h=100;
		double sum=100;
		for(int i=1;i<=num;i++){
			h=h/2;
			sum+=h;			
		}
		System.out.println("��3�θ߶���:"+h);
		return sum;	
	}
}
