import Vue from 'vue'
import Router from 'vue-router'

// Common
import Main from "@/pages/Main"
import TheHeader from "@/pages/common/TheHeader"

// User
import Login from "@/pages/user/Login"
import Join from "@/pages/user/Join"
import MyPage from "@/pages/user/MyPage"
import Follower from "@/pages/user/Follower"

// Review
import ReviewWrite from "@/pages/review/ReviewWrite"
import ReviewDetail from "@/pages/review/ReviewDetail"
import ReviewListItem from "@/pages/review/ReviewListItem"
import ReviewList from "@/pages/review/ReviewList"
import ReviewModify from "@/pages/review/ReviewModify"

// Map
import Map from "@/pages/Map"

// Notice
import NoticeWrite from "@/pages/notice/NoticeWrite"
import NoticeDetail from "@/pages/notice/NoticeDetail"
import NoticeListItem from "@/pages/notice/NoticeListItem"
import NoticeList from "@/pages/notice/NoticeList"
import NoticeModify from "@/pages/notice/NoticeModify"

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Main,
    },
    {
      path: '/user/login',
      component: Login
    },
    {
      path: '/user/join',
      component: Join
    },
    {
      path: '/user/mypage',
      component: MyPage
    },
    {
      path: '/user/follower',
      component: Follower
    },
    {
      path: '/map',
      component: Map
    },
    {
      path: '/kakao',
      beforeEnter() {
        const clientId = '980d869835ee11e022c77686d37291f1';
        const redirectUri = 'http://localhost:80/user/api/kakao/callback';
        const responseType = 'code';
        const authUrl = `https://kauth.kakao.com/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&response_type=${responseType}`;
        window.location.href = authUrl;
      },
    },
    {
      path: '/review/list',
      component: ReviewList
    },
    {
      path: '/review/write',
      component: ReviewWrite
    },
    {
      path: '/review/detail/:review_id',
      component: ReviewDetail
    },
    {
      path: '/review/modify',
      component: ReviewModify
    },
    {
      path: '/notice/list',
      component: NoticeList
      
    },
    {
      path: '/notice/write',
      component: NoticeWrite
    },
    {
      path: '/notice/detail',
      component: NoticeDetail
    },
    {
      path: '/notice/modify',
      component: NoticeModify
    },
  ]
})
