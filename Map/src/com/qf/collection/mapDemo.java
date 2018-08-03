package com.qf.collection;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class mapDemo {

	public static void main(String[] args) {
		Map<String,String> map=new HashMap<>();
		map.put("����","10086");
		map.put("����","12306");
		map.put("�����","45678");
		//����һ��ʹ��map��EntrySet()��������
		Set<Map.Entry<String,String>> set=map.entrySet();
		for (Map.Entry<String, String> me : set) {
			System.out.println(me.getKey()+"="+me.getValue());
		}
		System.out.println("*****");
		//��������ͨ��keySet()���ؼ��ϵ�iterator����
		Iterator<String>iter=map.keySet().iterator();
		while(iter.hasNext()){
			String key=iter.next();
			System.out.println(key+"="+map.get(key));
		}
		System.out.println("############");
		//��������ʹ��keySet()��������
		for ( String key : map.keySet()) {
			System.out.println(key+"="+map.get(key));
		}
		//����valueֵ
		for (String value:map.values()) {
			System.out.println(value);
		}
	}
}
