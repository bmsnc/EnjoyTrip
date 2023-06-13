	
package com.ssafy.trip.service.place;

import com.ssafy.trip.dto.place.PlaceDto;
import com.ssafy.trip.dto.place.PlanPlaceDto;
import com.ssafy.trip.dto.place.PlaneDto;
import com.ssafy.trip.dto.place.RouteDto;
import com.ssafy.trip.repository.place.PlaceRepository;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PlaceServiceImpl implements PlaceService {
    private static int size, orderBy_dis_max_dis , orderBy_dis_max_time, orderBy_time_max_dis, orderBy_time_max_time, time, dis;
    private static boolean v[];
    private static int[][][] d; // 0 시간, 1 거리
    private static int[] orderByTime, orderByDis;

private PlaceRepository placeRepository;


public PlaceServiceImpl(PlaceRepository placeRepository) {
    this.placeRepository = placeRepository;
}


@Override
public void placeInfo(PlaceDto placeDto) {
    placeRepository.placeInfo(placeDto);
}

@Override
public PlaceDto infoByPlaceId(String place_id) {
    return placeRepository.infoByPlaceId(place_id);
}

@Override
public List<String> placeIdByPlanId(int plan_id) {
    return placeRepository.placeIdByPlanId(plan_id);
}

@Override
public void deletePlanPlace(int plan_id) {
    placeRepository.deletePlanPlace(plan_id);
}

@Override
public void addPlanPlace(PlanPlaceDto planPlaceDto) {
    placeRepository.addPlanPlace(planPlaceDto);
}

@Override
public boolean checkPlaceId(String place_id) {
    if (placeRepository.checkPlaceId(place_id) > 0) return true;
    return false;
}

@Override
public Map<String, Object> findPath(Map<String, Object> map, int len) {

    Map<String, Object> resMap = new HashMap<>();

    size = len;
    
    v = new boolean[size];
    d = new int[size][size][2];
    orderByTime = new int[size];
    orderByDis = new int[size];


    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (i == j) continue;
            
            String origin, destination;
            Map<String,Object> start = (Map<String, Object>) map.get(i+"");
            Map<String,Object> end = (Map<String, Object>) map.get(j+"");

            origin = (String) start.get("place_id");
            destination = (String) end.get("place_id");
            String url = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=place_id:" + origin + "&destination=place_id:" + destination + "&key=*YourServiceKey*&mode=DRIVING";
            System.out.println(url);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map<String, Object>> responseEntity = restTemplate.exchange(url, HttpMethod.POST, new HttpEntity<>(headers), new ParameterizedTypeReference<Map<String, Object>>() {});
            if (responseEntity.getStatusCodeValue() == 200) {
            	System.out.println(123);
                Map<String, Object> jsonResponse = responseEntity.getBody();
                System.out.println(jsonResponse);
                List<Map<String,Object>> routes = (List<Map<String, Object>>) jsonResponse.get("routes");
                System.out.println(routes);
                Map<String, Object> firstRoute = routes.get(0);
                List<Map<String, Object>> legs = (List<Map<String, Object>>) firstRoute.get("legs");
                Map<String, Object> res = legs.get(0);
                Map<String,Object> distance = (Map<String, Object>) res.get("distance");
                String dis = (String) distance.get("text");
                Map<String,Object> duration = (Map<String, Object>) res.get("duration");
                String time = (String) duration.get("text");
                
                System.out.println((String) start.get("formatted_address") + (String)end.get("formatted_address"));
                System.out.println(dis + "  " + time);
                String[] s = dis.split(" ");
                System.out.println(Arrays.toString(s));
                try {
                	if (s[0].length() > 3) {
                		String temp = "";
                		for (int k = 0; k < s[0].length(); k++) {
							if (s[0].charAt(k) == ',') continue;
							temp += s[0].charAt(k);
						}
                		System.out.println(temp);
                		d[i][j][0] = Integer.parseInt(temp);
                	}else {
                		d[i][j][0] = Integer.parseInt(s[0]);	
                	}                	
                }catch(Exception e) {
                	e.printStackTrace();
                	d[i][j][0] = 0;
                }
                
                String[] s1 = time.split(" ");
                System.out.println(Arrays.toString(s1));
                int t = 0;
                try {
                	if (s1.length > 2){    
                		if (s1[1].equals("day") || s1[1].equals("days")) {
                			t += Integer.parseInt(s1[0]) * 60 * 24;
                			t += Integer.parseInt(s1[2]) * 60;
                		}else if(s1[1].equals("hour") || s1[1].equals("hours")){
                			t += Integer.parseInt(s1[0]) * 60;
                			t += Integer.parseInt(s1[2]);
                		}                                                
                    }else{
                        t += Integer.parseInt(s1[0].trim());
                    }                	
                }catch(Exception e) {
                	e.printStackTrace();
                	t = -100000;
                }                
                
                d[i][j][1] = t;
                d[j][i][1] = t;
            }
        }
    }
//    for (int i = 0; i < size; i++) {
//		for (int j = 0; j < size; j++) {
//			System.out.println(i + " -> " + j  + " " + d[i][j][0]);
//			System.out.println(i + " -> " + j  + " " + d[i][j][1]);
//		}
//	}    

    
    time = Integer.MAX_VALUE;
    dis = Integer.MAX_VALUE;
    
    
    recursive(0, new int[size]);

    resMap.put("orderByTime",Arrays.toString(orderByTime));
    resMap.put("orderByDis",Arrays.toString(orderByDis));
    resMap.put("orderBy_dis_max_dis", orderBy_dis_max_dis);
    resMap.put("orderBy_dis_max_time", orderBy_dis_max_time);
    resMap.put("orderBy_time_max_dis", orderBy_time_max_dis);
    resMap.put("orderBy_time_max_time", orderBy_time_max_time);
    
    
    
    
    return resMap;
}

    @Override
    public void insertPlane(PlaneDto planeDto) {
        placeRepository.insertPlane(planeDto);
    }

    @Override
    public void insertRoute(RouteDto routeDto) {
        placeRepository.insertRoute(routeDto);
    }

    @Override
    public void deletePlane(int plan_id) {
        placeRepository.deletePlane(plan_id);
    }

    @Override
    public void updatePlane(PlaneDto planeDto) {
        placeRepository.updatePlane(planeDto);
    }

    @Override
    public void deleteRoute(int plan_id) {
        placeRepository.deleteRoute(plan_id);
    }

    @Override
    public void updateRoute(RouteDto routeDto) {
        placeRepository.updateRoute(routeDto);
    }

    public void recursive(int idx, int[] sel){

    if (idx >= size){        
        int total_dis = 0;
        int total_time = 0;
        for (int i = 0; i < size - 1; i++) {
            total_time += d[sel[i]][sel[i+1]][0];
            total_dis += d[sel[i]][sel[i+1]][1];
        }
        // 거리 : 가장 짧은 거리 경로 반환
        if (dis > total_dis){
        	dis = total_dis;
        	orderBy_dis_max_dis = total_dis;
            orderBy_dis_max_time = total_time;
            orderByDis = Arrays.copyOf(sel, size);
            
        }
        // 시간 : 가장 짧은 시간 경로 반환
        if (time > total_time){
        	time = total_time;
        	orderBy_time_max_dis = total_dis;
        	orderBy_time_max_time = total_time;
        	orderByTime = Arrays.copyOf(sel, size);
        	
        }
        return;
    }

    for (int i = 0; i < size; i++) {
        if (v[i]) continue;
        v[i] = true;
        sel[idx] = i;
        recursive(idx+1, sel);
        v[i] = false;
    }
}
}