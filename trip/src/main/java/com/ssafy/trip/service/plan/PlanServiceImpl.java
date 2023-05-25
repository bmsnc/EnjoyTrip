package com.ssafy.trip.service.plan;

import com.ssafy.trip.dto.place.PlaneDto;
import com.ssafy.trip.dto.place.RouteDto;
import com.ssafy.trip.dto.plan.PlanDto;
import com.ssafy.trip.dto.plan.UserPlanDto;
import com.ssafy.trip.repository.plan.PlanRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlanServiceImpl implements PlanService{

    private PlanRepository planRepository;

    public PlanServiceImpl(PlanRepository planRepository) {
        this.planRepository = planRepository;
    }

    @Override
    public List<PlanDto> planList() {
        return planRepository.planList();
    }

    @Override
    public List<PlanDto> following_list(String user_id) {
        return planRepository.following_list(user_id);
    }

    @Override
    public List<PlanDto> listByUserId(String user_id) {
        return planRepository.listByUserId(user_id);
    }

    @Override
    public PlanDto detailByPlanId(int plan_id) {
        return planRepository.detailByPlanId(plan_id);
    }

    @Override
    public void makePlan(PlanDto planDto) {
        planRepository.makePlan(planDto);
    }

    @Override
    public void updatePlan(PlanDto planDto) {
        planRepository.updatePlan(planDto);
    }

    @Override
    public void deletePlan(int plan_id) {
        planRepository.deletePlan(plan_id);
    }

    @Override
    public int getPlanId(String user_id) {
        return planRepository.getPlanId(user_id);
    }

    @Override
    public void updateHit(int plan_id) {
        planRepository.updateHit(plan_id);
    }

    @Override
    public void upLike(int plan_id) {
        planRepository.upLike(plan_id);
    }

    @Override
    public void downLike(int plan_id) {
        planRepository.downLike(plan_id);
    }

    @Override
    public void makeLike(PlanDto planDto) {
        planRepository.makeLike(planDto);
    }

    @Override
    public void deleteLike(PlanDto planDto) {
        planRepository.deleteLike(planDto);
    }

    @Override
    public void userPlanMake(UserPlanDto userPlanDto) {
        planRepository.userPlanMake(userPlanDto);
    }

    @Override
    public void userPlanUpdate(UserPlanDto userPlanDto) {
        planRepository.userPlanUpdate(userPlanDto);
    }

    @Override
    public void userPlanDelete(int plan_id) {
        planRepository.userPlanDelete(plan_id);
    }

    @Override
    public List<UserPlanDto> planPlace(int plan_id) {
        return planRepository.planPlace(plan_id);
    }

    @Override
    public List<PlaneDto> planPlane(int plan_id) {
        return planRepository.planPlane(plan_id);
    }

    @Override
    public List<RouteDto> planRoute(int plan_id) {
        return planRepository.planRoute(plan_id);
    }

    @Override
    public void modify(PlanDto planDto) {
        planRepository.modify(planDto);
    }

    @Override
    public int planIdByUserId(String user_id) {
        return planRepository.planIdByUserId(user_id);
    }


}
