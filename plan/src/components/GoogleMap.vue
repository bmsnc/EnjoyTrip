
<template>
  <div class="ui grid">
    <div class="four wide column">
      <form class="ui segment large form">
        <div class="ui segment">
          <div class="field">
            <div class="ui right icon input large">
              <input type="text" v-model="title" ref="autocomplete" />
              <button class="ui button" @click="search">검색</button>
            </div>
          </div>
        </div>
        <div>
          <button @click="centerMap(curX, curY, $event)">현재 위치</button>
        </div>

        <div class="flex-container">
          <div class="flex-row">
            <button class="custom-button ui button" @click="checkPlace">
              장소 검색
            </button>
            <button class="custom-button ui button" @click="checkNearBy">
              주변 검색
            </button>
            <button class="custom-button ui button" @click="checkRoad">
              길찾기
            </button>
          </div>
          <div class="flex-row">
            <button class="custom-button ui button" @click="checkRoute">
              경로 찾기
            </button>
            <button class="custom-button ui button" @click="checkAir">
              항공권
            </button>
            <button class="custom-button ui button" @click="checkHotel">
              호텔
            </button>
          </div>
        </div>
      </form>

      <div v-if="identifier === 'place'">
        <label>장소를 입력해 주세요</label>
      </div>

      <div v-if="identifier === 'nearby'">
        <label>주변 거리를 선택해 주세요</label>
        <div class="field">
          <div class="field">
            거리 선택
            <select v-model="radius">
              <option value="1">1 KM</option>
              <option value="5">5 KM</option>
              <option value="10">10 KM</option>
              <option value="15">15 KM</option>
              <option value="20">20 KM</option>
            </select>
          </div>
        </div>
      </div>

      <div v-if="identifier === 'road'">
        <div class="field">
          <div class="two fields">
            <div class="field ui right icon input">
              <label>출발:</label>
              <input type="text" v-model="findA" ref="start" />
            </div>
            <div class="field ui right icon input">
              <label>도착:</label>
              <input type="text" ref="end" />
            </div>
          </div>
        </div>
        <button class="custom-button ui button" @click="checkTrans">
          경로 검색
        </button>
        <button class="ui button" @click="byTrans">대중교통</button>
        <button class="ui button" @click="byCar">자동차</button>
      </div>

      <!-- here ******************************************************************************************************************************************************************************************************************************************************** -->

      <div v-if="identifier === 'route'">
        <div class="field">
          <div class="field ui right icon input">
            <label>경로 추가</label>
            <input type="text" ref="add" />
          </div>
        </div>
        <button class="ui button" @click="drawRoute">그리기</button>
        <button class="ui button" @click="findRoute">최적 경로</button>

        <div v-if="isCheckOpt">
            <button class="ui button" @click="sortByTime">시간</button>
            <button class="ui button" @click="sortByDis">거리</button>
        </div>

        <div v-if="isCheckOpt && isTime" class="ui segment" style="max-height: 500px; overflow: scroll">
            <div class="field">
            <div class="ui divided items field">
              <div class="item" v-for="(route, index) in timeRoute" :key="index">
                <div class="content">
                  <a :href="route.url" target="_blank">
                    <img :src="route.photo" width="50" height="50" />
                  </a>
                  <td @click="centerMap(route.lat, route.lng, $event)">
                    {{
                      route.formatted_address ? route.formatted_address : "-"
                    }}
                  </td>
                </div>
                <td>                  
                </td>
              </div>
            </div>
            <button class="ui button" @click="addPlanRoute(timeRoute)">추가</button>
          </div>
          <div class="field">
            <label>총 시간: {{this.timeByTimeH}} 시간 {{this.timeByTimeM}} 분 총 거리: {{this.disByTime}} km</label>
            </div>            
        </div>
        <div v-if="isCheckOpt && isDis" class="ui segment" style="max-height: 500px; overflow: scroll">
            <div class="field">
            <div class="ui divided items field">
              <div class="item" v-for="(route, index) in disRoute" :key="index">
                <div class="content">
                  <a :href="route.url" target="_blank">
                    <img :src="route.photo" width="50" height="50" />
                  </a>
                  <td @click="centerMap(route.lat, route.lng, $event)">
                    {{
                      route.formatted_address ? route.formatted_address : "-"
                    }}
                  </td>
                </div>
                <td>              
                </td>
              </div>
            </div>
            <button class="ui button" @click="addPlanRoute(disRoute)">추가</button>
          </div>     
          <div class="field">
            <label>총 시간: {{this.timeByDisH}} 시간 {{this.timeByDisM}} 분 총 거리: {{this.disByDis}} km</label>
            </div>            
        </div>


        <div
          v-if="addRoute.length > 0 && isNormal"
          class="ui segment"
          style="max-height: 500px; overflow: scroll"
        >
          <div class="field">
            <div class="ui divided items field">
              <div class="item" v-for="(route, index) in addRoute" :key="index">
                <div class="content">
                  <a :href="route.url" target="_blank">
                    <img :src="route.photo" width="50" height="50" />
                  </a>
                  <td @click="centerMap(route.lat, route.lng, $event)">
                    {{
                      route.formatted_address ? route.formatted_address : "-"
                    }}
                  </td>
                </div>
                <td>
                  <button
                    class="ui button"
                    @click="deleteAddRoute(index, $event)"
                  >
                    삭제
                  </button>
                </td>
              </div>
            </div>
            <button class="ui button" @click="addPlanRoute(addRoute)">추가</button>
          </div>
        </div>
      </div>

      <!-- here ******************************************************************************************************************************************************************************************************************************************************** -->

      <div v-if="identifier === 'air'">
        <div class="field">
          <div>
            <label>출발 날짜</label>
            <input type="date" v-model="airStartDate" />
          </div>
          <div>
            <label>출발 시간</label>
            <input type="time" v-model="airStartTime" step="1" />
          </div>
        </div>
        <div>
          <label>출발 공항</label>
          <select v-model="departureAirport">
            :
            <option
              v-for="(airport, index) in airports"
              :value="airport.code"
              :key="index"
            >
              {{ airport.name }} ({{ airport.country }})
            </option>
          </select>
        </div>

        <div>
          <label>도착 공항</label>
          <select v-model="arrivalAirport">
            <option
              v-for="(airport, index) in airports"
              :value="airport.code"
              :key="index"
            >
              {{ airport.name }} ({{ airport.country }})
            </option>
          </select>
        </div>

        <div>
          <label>좌석</label>
          <select v-model="seat">
            <option
              v-for="(grade, index) in grades"
              :value="grade.value"
              :key="index"
            >
              {{ grade.name }}
            </option>
          </select>
        </div>

        <div
          v-if="planes.length > 0"
          class="ui segment"
          style="max-height: 500px; overflow: scroll"
        >
          <div class="field">
            <div class="ui divided items field">
              <div class="item" v-for="(plane, index) in planes" :key="index">
                <div class="content">
                  <div class="header">
                    {{ plane[0].departure }} -> {{ plane[0].arrival }}
                  </div>
                  <div class="meta">
                    {{ plane[0].carrierCode }} 가격:{{ plane[0].price }}
                  </div>
                  <div class="meta">
                    잔여석:{{ plane[0].numberOfBookableSeats }} 경유횟수:{{
                      plane[0].numberOfStops
                    }}
                  </div>
                </div>
                <td>
                  <button class="ui button" @click="makeAir(plane)">
                    추가
                  </button>
                </td>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div
        v-if="transits.length > 0 && drive === 'bus' && identifier === 'road'"
        class="ui segment"
        style="max-height: 500px; overflow: scroll"
      >
        <div class="two fields">
          <div class="field">{{ findA }} -> {{ findB }}</div>
          <td>
            <button class="ui button" @click="drawTransit">그리기</button>
          </td>
          
        </div>
        <div class="field">
          <div class="ui divided items field">
            <div class="item" v-for="(transit, index) in transits" :key="index">
              <button @click="transit[0].show = !transit[0].show">
                상세 보기
              </button>
              <div class="content">
                <div class="meta">{{ transit[0].totalDis }}</div>
                <div class="meta">{{ transit[0].totalDur }}</div>
              </div>
              <div v-show="transit[0].show">
                <div
                  class="item"
                  v-for="(info, i) in transit[0].distance.length"
                  :key="i"
                >
                  <div class="header">
                    {{ transit[0].html_instructions[i] }}
                  </div>
                  <div class="meta">{{ transit[0].distance[i] }}</div>
                  <div class="meta">{{ transit[0].duration[i] }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div
        v-if="car.length > 0 && drive === 'drive' && identifier === 'road'"
        class="ui segment"
        style="max-height: 500px; overflow: scroll"
      >
        <div class="two fields">
          <div class="field">{{ findA }} -> {{ findB }}</div>
          <td>
            <button class="ui button" @click="drawDriving">그리기</button>
          </td>
          
        </div>
        <div class="field">
          <div class="ui divided items field">
            <div class="item" v-for="(info, index) in car" :key="index">
              <div class="content">
                <div class="meta">{{ info.distance }}</div>
                <div class="meta">{{ info.duration }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div
        v-if="hotels.length > 0 && identifier === 'hotel'"
        class="ui segment"
        style="max-height: 500px; overflow: scroll"
      >
        <table>
          <thead>
            <th>사진</th>
            <th>주소</th>
            <th>추가</th>
          </thead>
          <tbody v-for="(hotel, index) in hotels" :key="index">
            <tr>
              <td>
                <a :href="hotel.url" target="_blank">
                  <img :src="hotel.photo" width="50" height="50" />
                </a>
              </td>
              <td
                @click="
                  centerMap(hotel.geometry.location.lat,hotel.geometry.location.lng,$event)">
                {{ hotel.formatted_address ? hotel.formatted_address : "-" }}
              </td>
              <td>
                <button class="ui button" @click="makePlan(hotel)">추가</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div
        v-if="
          places.length > 0 &&
          (identifier === 'nearby' || identifier === 'place')
        "
        class="ui segment"
        style="max-height: 500px; overflow: scroll"
      >
        <table>
          <thead>
            <th>사진</th>
            <th>주소</th>
            <th>추가</th>
          </thead>
          <tbody v-for="place in places" :key="place.id">
            <tr>
              <td>
                <a :href="place.url" target="_blank">
                  <img :src="place.photo" width="50" height="50" />
                </a>
              </td>
              <td
                @click="
                  centerMap(
                    place.geometry.location.lat,
                    place.geometry.location.lng,
                    $event
                  )
                "
              >
                {{ place.formatted_address ? place.formatted_address : "-" }}
              </td>
              <td>
                <button class="ui button" @click="makePlan(place)">추가</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <div
      class="eight wide column segment ui"
      id="map"
      ref="map"
      style="height: 90vh"
    ></div>

    <div class="four wide column">
      <form class="ui segment large form" ref="myForm">
        <h3>{{user_id}} 의 두근두근 여행</h3>

        <div class="field">
          <div class="two fields">
            <div class="field">
              <label>Start Date</label>
              <input
                type="date"
                id="start_date"
                name="start_date"
                v-model="start_date"
              />
            </div>
            <div class="field">
              <label>End Date</label>
              <input
                type="date"
                id="end_date"
                name="end_date"
                v-model="end_date"
              />
            </div>
          </div>
        </div>
        
        <div class="field">
          <div class="two fields">
            <div class="field" v-if="resPlane.length > 0">
              <label>항공권</label>
              <div class="item" v-for="(plane, index) in resPlane" :key="index" id = "planes" name = "planes">
                <div class="content">
                  <div class="header">
                    {{ plane[0].departure }} -> {{ plane[0].arrival }}
                  </div>
                  <div class="meta">
                    {{ plane[0].carrierCode }} 가격:{{ plane[0].price }}
                  </div>
                  <!-- <div class="meta">잔여석:{{plane[0].numberOfBookableSeats}} 경유횟수:{{plane[0].numberOfStops}}</div> -->
                </div>
                <td>
                  <button class="ui button" @click="deleteAir(plane, $event)">
                    삭제
                  </button>
                </td>
              </div>
            </div>
            <div class="field" v-if="resRoute.length > 0">
              <label>경로</label>
              <div class="item" v-for="(routes, index) in resRoute" :key="index">
                <div class="item" v-for="(route, i) in routes" :key="i">

                     <div class="content">
                  <a :href="route.url" target="_blank">
                    <img :src="route.photo" width="50" height="50" />
                  </a>
                  <div @click="centerMap(route.lat, route.lng, $event)">
                    {{
                      route.formatted_address ? route.formatted_address : "-"
                    }}
                  </div>
                  </div>                    
                  </div>
                  <button class="ui button" @click="deleteResRoute(index, $event)">삭제</button>
                </div>
            </div>
            
          </div>
        </div>

        <div class="field">
          <label style="text-align: left">Title</label>
          <input id="title" v-model="plan_title" name="title" type="text" />
        </div>

        <table v-if="plans.length > 0">
          <thead>
            <th>Places</th>
          </thead>
          <tbody
            v-for="plan in plans"
            :key="plan.id"
            id="place_id"
            name="place_id"
          >
            <tr>
              <td>
                <a :href="plan.url" target="_blank">
                  <img :src="plan.photo" width="50" height="50" />
                </a>
              </td>
              <td
                @click="
                  centerMap(
                    plan.geometry.location.lat,
                    plan.geometry.location.lng,
                    $event
                  )
                "
              >
                {{ plan.formatted_address ? plan.formatted_address : "-" }}
              </td>
              <td>
                <button class="ui button" @click="deletePlan(plan, $event)">
                  삭제
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="field">
          <label style="text-align: left">Content</label>
          <textarea
            id="content"
            name="content"
            v-model="content"
            style="height: 200px; resize: vertical"
          ></textarea>
        </div>
      </form>
      <router-link :to="`/plan/list`" class="plan-card-link">
      <button class="ui button" @click="submitForm">작성</button>
      </router-link>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import { http } from "@/api/http";
import _ from 'lodash';

// 장소 검색, 주변 검색, 길 찾기, 최적경로, 항공권, 호텔
export default {
  data() {
    return {
      map: "",
      user_id: JSON.parse(sessionStorage.getItem("userInfo")).user_id,
      curX: "",
      curY: "",
      searchX: "",
      searchY: "",
      address: "",
      title: "",
      places: [],
      plans: [],
      start_date: "",
      end_date: "",
      plan_title: "",
      content: "",
      plan_id: "",
      markers: [],
      identifier: "",
      radius: 1,
      greenMarkers: [],
      disRoute: [],
      timeRoute: [],
      timeByDisH:"",
      timeByDisM:"",
      disByDis:"",
      timeByTimeH:"",
      timeByTimeM:"",
      disByTime:"",
      start: "",
      end: "",
      transits: [],
      findA: "",
      findB: "",
      drive: "bus",
      car: [],
      hotels: [],
      resRoute: [],
      addRoute: [],
      resPlane: [],
      origin: [],
      destination: [],
      check: "bus",
      isDraw: false,
      planes: [],
      airStartDate: "",
      airStartTime: "",
      arrivalAirport: "",
      departureAirport: "",
      seat: "",
      isCheckOpt: false,
      isNormal: true,
      isTime: false,
      isDis: false,
      grades: [
        { value: "BUSINESS", name: "BUSINESS" },
        { value: "ECONOMY", name: "ECONOMY" },
      ],
      airports: [
        { code: "ICN", name: "인천국제공항", country: "대한민국" },
        { code: "GMP", name: "김포국제공항", country: "대한민국" },
        { code: "CJU", name: "제주국제공항", country: "대한민국" },
        { code: "PUS", name: "김해국제공항", country: "대한민국" },

        { code: "NRT", name: "도쿄 나리타국제공항", country: "일본" },
        { code: "HND", name: "도쿄 하네다국제공항", country: "일본" },
        { code: "KIX", name: "오사카 국제공항", country: "일본" },
        { code: "CTS", name: "신치토세 츠르마이 국제공항", country: "일본" },
        { code: "FUK", name: "후쿠오카 국제공항", country: "일본" },
        { code: "OKA", name: "오키나와 나하국제공항", country: "일본" },
        { code: "NGO", name: "나고야 차우센국제공항", country: "일본" },
        { code: "ITM", name: "오사카 이타미국제공항", country: "일본" },
        { code: "SDJ", name: "시라쓰 공항", country: "일본" },
        { code: "HIS", name: "히메지 공항", country: "일본" },

        { code: "PEK", name: "베이징국제공항", country: "중국" },
        { code: "PVG", name: "상하이 푸동국제공항", country: "중국" },
        { code: "CAN", name: "광저우 바이유국제공항", country: "중국" },
        { code: "SHA", name: "상하이 홍차오국제공항", country: "중국" },
        { code: "CTU", name: "청두 샹리우 국제공항", country: "중국" },
        { code: "SZX", name: "심천 보안국제공항", country: "중국" },
        { code: "HGH", name: "항저우 송양 국제공항", country: "중국" },
        { code: "XIY", name: "서안시 셴양 국제공항", country: "중국" },
        { code: "KMG", name: "쿤밍 창승 국제공항", country: "중국" },
        { code: "TNA", name: "진남 샤옌 국제공항", country: "중국" },

        { code: "SGN", name: "호치민 시티 국제공항", country: "베트남" },
        { code: "HAN", name: "하노이 국제공항", country: "베트남" },
        { code: "DAD", name: "다낭 국제공항", country: "베트남" },
        { code: "CXR", name: "남오섬 국제공항", country: "베트남" },
        { code: "PQC", name: "푸꾸옥 국제공항", country: "베트남" },

        { code: "TPE", name: "타이베이 타오위안 국제공항", country: "대만" },
        { code: "TSA", name: "타이베이 송산 국제공항", country: "대만" },
        { code: "KHH", name: "가오슝 국제공항", country: "대만" },
        { code: "RMQ", name: "타이중 국제공항", country: "대만" },
        { code: "HUN", name: "훈주 국제공항", country: "대만" },

        { code: "JFK", name: "뉴욕 존 F. 케네디 국제공항", country: "미국" },
        { code: "LAX", name: "로스앤젤레스 국제공항", country: "미국" },
        { code: "ORD", name: "시카고 오헤어 국제공항", country: "미국" },
        { code: "DFW", name: "다라스 포트워스 국제공항", country: "미국" },
        {
          code: "ATL",
          name: "애틀랜타 하츠필드-잭슨 국제공항",
          country: "미국",
        },
        { code: "SFO", name: "샌프란시스코 국제공항", country: "미국" },
        { code: "DEN", name: "덴버 국제공항", country: "미국" },
        { code: "SEA", name: "시애틀 타코마 국제공항", country: "미국" },
        { code: "MIA", name: "마이애미 국제공항", country: "미국" },
        { code: "LAS", name: "라스베이거스 매캐런 국제공항", country: "미국" },

        { code: "MNL", name: "마닐라 니노이 야콥 국제공항", country: "필리핀" },
        { code: "CEB", name: "세부 마크스 국제공항", country: "필리핀" },
        { code: "DVO", name: "다바오 국제공항", country: "필리핀" },
        { code: "CRK", name: "앙헬레스 클락 국제공항", country: "필리핀" },
        { code: "ILO", name: "일로일로 국제공항", country: "필리핀" },
        { code: "PPS", name: "푸에르토 프린세사 국제공항", country: "필리핀" },
        { code: "USU", name: "부산국제공항", country: "필리핀" },
        { code: "TAG", name: "타갈로간 국제공항", country: "필리핀" },
        { code: "CBO", name: "코타바토 국제공항", country: "필리핀" },
        { code: "BWN", name: "브루나이 국제공항", country: "필리핀" },

        { code: "HKG", name: "홍콩국제공항", country: "홍콩" },
        { code: "BKK", name: "방콕 수완나품국제공항", country: "태국" },

        { code: "LHR", name: "런던 히드로우 국제공항", country: "영국" },
        { code: "LGW", name: "런던 갓윅 국제공항", country: "영국" },
        { code: "MAN", name: "맨체스터 국제공항", country: "영국" },
        { code: "EDI", name: "에딘버러 공항", country: "영국" },
        { code: "BHX", name: "버밍엄 국제공항", country: "영국" },

        { code: "CDG", name: "파리 찰스 드골 국제공항", country: "프랑스" },
        { code: "ORY", name: "파리 오를리 국제공항", country: "프랑스" },
        { code: "NCE", name: "니스 코트다쥐르 국제공항", country: "프랑스" },
        { code: "MRS", name: "마르세유 프보 국제공항", country: "프랑스" },
        { code: "LYS", name: "리옹-샹티에 국제공항", country: "프랑스" },

        { code: "FRA", name: "프랑크푸르트 국제공항", country: "독일" },
        { code: "MUC", name: "뮌헨 국제공항", country: "독일" },
        { code: "TXL", name: "베를린 티겔 국제공항", country: "독일" },
        { code: "HAM", name: "함부르크 공항", country: "독일" },
        { code: "DUS", name: "뒤셀도르프 국제공항", country: "독일" },

        {
          code: "AMS",
          name: "암스테르담 스키폴 국제공항",
          country: "네덜란드",
        },
        { code: "RTM", name: "로테르담 국제공항", country: "네덜란드" },
        { code: "EIN", name: "에인트호벤 국제공항", country: "네덜란드" },
        { code: "GRQ", name: "훈스틴 국제공항", country: "네덜란드" },
        {
          code: "MST",
          name: "마스트리히트 에이포트 국제공항",
          country: "네덜란드",
        },

        { code: "MAD", name: "마드리드 바라하스 국제공항", country: "스페인" },
        {
          code: "BCN",
          name: "바르셀로나 엘 프라트 국제공항",
          country: "스페인",
        },
        { code: "AGP", name: "말라가 국제공항", country: "스페인" },
        {
          code: "PMI",
          name: "마요르카 팔마 데 말리로르카 국제공항",
          country: "스페인",
        },
        { code: "TFS", name: "테네리페 남부 공항", country: "스페인" },

        { code: "FCO", name: "로마 피우미치노 국제공항", country: "이탈리아" },
        { code: "MXP", name: "밀라노 말펜사 국제공항", country: "이탈리아" },
        {
          code: "VCE",
          name: "베니스 마르코 폴로 국제공항",
          country: "이탈리아",
        },
        {
          code: "CTA",
          name: "카타니아 폰타나로사 국제공항",
          country: "이탈리아",
        },
        {
          code: "NAP",
          name: "나폴리 카푸따시멘티 국제공항",
          country: "이탈리아",
        },

        { code: "YVR", name: "밴쿠버 국제공항", country: "캐나다" },
        { code: "YYZ", name: "토론토 피어슨 국제공항", country: "캐나다" },
        {
          code: "YUL",
          name: "몬트리올 피에르 엘리오트 트뤼도 국제공항",
          country: "캐나다",
        },
        { code: "YEG", name: "에드먼턴 국제공항", country: "캐나다" },
        {
          code: "YOW",
          name: "오타와 맥도널드-카티에 국제공항",
          country: "캐나다",
        },

        { code: "IST", name: "이스탄불 공항", country: "터키" },
        { code: "SAW", name: "이스탄불 사비하 공항", country: "터키" },
        { code: "AYT", name: "안탈리아 앤탈리아 공항", country: "터키" },
        { code: "ESB", name: "앙카라 에센보아 공항", country: "터키" },
        { code: "ADB", name: "이즈미르 아딜레 공항", country: "터키" },

        { code: "ZRH", name: "취리히 공항", country: "스위스" },
        { code: "GVA", name: "제네바 공항", country: "스위스" },
        { code: "BSL", name: "바젤-믈쩌하우젠 공항", country: "스위스" },
        { code: "ZRH", name: "취리히 공항", country: "스위스" },
        { code: "GVA", name: "제네바 공항", country: "스위스" },

        {
          code: "SYD",
          name: "시드니 킨스퍼드 스미스 국제공항",
          country: "호주",
        },
        { code: "MEL", name: "멜버른 탈라마린 국제공항", country: "호주" },
        { code: "BNE", name: "브리즈번 국제공항", country: "호주" },
        { code: "PER", name: "퍼스 국제공항", country: "호주" },
        { code: "ADL", name: "애들레이드 국제공항", country: "호주" },

        { code: "SIN", name: "싱가포르 창이국제공항", country: "싱가포르" },
        {
          code: "EZE",
          name: "부에노스아이레스 국제공항",
          country: "아르헨티나",
        },
        {
          code: "AEP",
          name: "부에노스아이레스 제리코레스 국제공항",
          country: "아르헨티나",
        },
        { code: "COR", name: "코르도바 국제공항", country: "아르헨티나" },
        { code: "MDZ", name: "멘도사 국제공항", country: "아르헨티나" },
        {
          code: "BRC",
          name: "산 카를로스 드 바리로체 국제공항",
          country: "아르헨티나",
        },
        { code: "GUM", name: "괌 국제공항", country: "미국령 괌" },
        { code: "ROP", name: "롭 공항", country: "미국령 괌" },
        { code: "SPN", name: "사이판 국제공항", country: "미국령 괌" },
        { code: "TIQ", name: "티니안 국제공항", country: "미국령 괌" },
        { code: "UAM", name: "안더스 국제공항", country: "미국령 괌" },
      ],
    };
  },
  watch: {
    // Watch for changes in the form data
    start_date: {
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 5000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    end_date: {
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 5000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    plan_title: {
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 5000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    plans: {
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 5000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    content: {
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 5000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    resRoute:{
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 10000), // 500ms 디바운스 지연 시간
      deep: true,
    },
    resPlane:{
      handler: _.debounce(function(newValue) {
        this.sendFormData();
      }, 10000), // 500ms 디바운스 지연 시간
      deep: true,
    }
  },
  computed: {
    coordinates() {
      return `${this.curX}, ${this.curY}`;
    },
  },

  created(){
    const user_id = this.user_id;
    console.log(user_id);

    http
    .get("plan/api/plan_id/" + user_id)
    .then((res) =>{
      console.log(res)
      const plan_id = res.data.plan_id;
      this.plan_id = plan_id;
      if (plan_id === undefined) return;

      http.get("/plan/api/detail/" + plan_id)
        .then((res) => {
          const plan = res.data.plan;
          this.start_date = plan.start_date;
          this.end_date = plan.end_date;
          this.content = plan.content;
          this.plan_title = plan.title          
          
        })
        .catch((error) => {
          console.error(error);
        });
       http.get("/plan/api/place/" + plan_id)
        .then((res) => {
          console.log(res)
          this.plans.push(res.data.list);
          console.log(this.plans)
        })
        .catch((error) => {
          console.error(error);
        });

        http.get("/plan/api/route/" + plan_id)
        .then((res) => {
          console.log(res)
          this.resRoute.push(res.data.list);
          console.log(this.resRoute)
        })
        .catch((error) => {
          console.log(res)
          console.error(error);
        });

        http.get("/plan/api/plane/" + plan_id)
        .then((res) => {
          console.log(res)
          this.resPlane.push(res.data.list);
          console.log(this.resPlane)
        })
        .catch((error) => {
          console.error(error);
        });


    }).catch((error) =>{
          console.error(error);
    }) 
    

  },

  mounted() {
    this.initMap();
  },

  methods: {
    
    addPlanRoute(route){
      let temp = route;
      this.resRoute.push(temp);
    },

    sortByTime(){
      this.isDis = false;
      this.isNormal = false;
      this.isTime = true;
    },
    sortByDis(){
      this.isTime = false;
      this.isNormal = false;
      this.isDis = true;
    },

    findRoute() {
      this.isCheckOpt = true;
      this.isNormal = true;
      this.isTime = false;
      this.isDis = false;
      const route = {};
      this.timeRoute = [];
      this.disRoute = [];

      for (var i = 0; i < this.addRoute.length; i++) {
        route[i] = this.addRoute[i];
      }
      route.size = this.addRoute.length;
      //https://maps.googleapis.com/maps/api/directions/json?origin=%EB%8F%84%EC%BF%84&destination=%EC%98%A4%EC%82%AC%EC%B9%B4&key=*YourServiceKey*&mode=DRIVING
      console.log(route);
      http
        .post("/plan/api/find", route)
        .then((response) => {
      
          let result = response.data.optroute;
          
          this.disByDis = result.orderBy_dis_max_dis;
          
          console.log(result.orderBy_dis_max_time);
          console.log(result.orderBy_time_max_time);

          // this.timeByDisH = Math.round(result.orderBy_dis_max_time / 60);
          // this.timeByDisM = Math.round(result.orderBy_dis_max_time % 60);
          
          this.timeByDisH = (result.orderBy_dis_max_time/ 60).toFixed(0);
          console.log(this.timeByDisH)
          this.timeByDisM = (result.orderBy_dis_max_time % 60).toFixed(0);
          console.log(this.timeByDisM)

          this.disByTime = result.orderBy_time_max_dis;
          this.timeByTimeH = (result.orderBy_time_max_time / 60).toFixed(0);
          this.timeByTimeM = (result.orderBy_time_max_time % 60).toFixed(0);

          for(var i = 0; i < result.orderByDis.length; i++){
            if (Number(result.orderByDis[i]) || result.orderByDis[i] == '0'){              
              this.disRoute.push(this.addRoute[result.orderByDis[i]]);
            }
          }
          
          for(var i = 0; i < result.orderByTime.length; i++){
            // console.log(result.orderByTime[i]);
            if (Number(result.orderByTime[i]) || result.orderByTime[i] == '0'){              
              this.timeRoute.push(this.addRoute[result.orderByTime[i]]);
            }
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },

    initMap() {

      console.log("맵 시작");
      let autocomplete = new google.maps.places.Autocomplete(
        this.$refs["autocomplete"],
        {
          bounds: new google.maps.LatLngBounds(),
        }
      );
      
      
            this.curX = 36.355;
            this.curY = 127.2983;
            
            this.searchX = 36.355;
            this.searchY = 127.2983;


            this.address = "대전 삼성 연수원";
            this.map = new google.maps.Map(this.$refs["map"], {
              zoom: 15,
              center: new google.maps.LatLng(this.curX, this.curY),
            });
            new google.maps.Marker({
              position: new google.maps.LatLng(this.curX, this.curY),
              animation: google.maps.Animation.DROP,
              map: this.map,
            });


          autocomplete.addListener("place_changed", () => {
            let place = autocomplete.getPlace();
            console.log(place);

             axios.get(`https://maps.googleapis.com/maps/api/place/details/json?key=*YourServiceKey*&place_id=` +place.place_id)
             .then(response => {
              console.log(response);
              var t = response.data.result;
              console.log(t);
              this.centerMap(
              t.geometry.location.lat,
              t.geometry.location.lng,
            );
          })


            // this.showUserLocationOnTheMap(
            //   place.geometry.location.lat(),
            //   place.geometry.location.lng()
            // );
          }); 

      // if (navigator.geolocation) {
        
        
      //   navigator.geolocation.getCurrentPosition((position) => {
          
      //     this.curX = position.coords.latitude;
      //     this.curY = position.coords.longitude;
          
      //     this.searchX = position.coords.latitude;
      //     this.searchY = position.coords.longitude;
          
      //     const baseURL =
      //       "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
      //     const location = this.curX + "," + this.curY;
      //     const radius = 5000;
      //     const keyword = encodeURIComponent(this.title); // 특수 문자가 포함될 수 있으므로 인코딩
      //     const apiKey = "*YourServiceKey*"; // 실제로 사용하는 구글 API 키로 대체해야 합니다.

      //     const url = `${baseURL}?location=${location}&radius=${radius}&keyword=${keyword}&key=${apiKey}`;
      //     console.log(url);
      //     axios.get(url).then((response) => {
      //       console.log("axios");
      //       this.address = response.data.results[0].formatted_address;
      //       this.map = new google.maps.Map(this.$refs["map"], {
      //         zoom: 15,
      //         center: new google.maps.LatLng(this.curX, this.curY),
      //       });
      //       new google.maps.Marker({
      //         position: new google.maps.LatLng(this.curX, this.curY),
      //         animation: google.maps.Animation.DROP,
      //         map: this.map,
      //       });
      //     });
      //   });
      // }
    },

    drawRoute() {
      var directionsService = new google.maps.DirectionsService();
      var directionsRenderer = new google.maps.DirectionsRenderer();

      var map = new google.maps.Map(this.$refs["map"]);

      var waypoints = [];
      for (var i = 1; i < this.addRoute.length - 1; i++) {
        waypoints.push({
          location: this.addRoute[i].formatted_address,
          stopover: true,
        });
      }

      var request = {
        origin: this.addRoute[0].formatted_address,
        destination: this.addRoute[this.addRoute.length - 1].formatted_address,
        waypoints: waypoints,
        optimizeWaypoints: true,
        travelMode: "DRIVING",
      };

      directionsService.route(request, function (response, status) {
        if (status === "OK") {
          directionsRenderer.setDirections(response);
        }
      });

      directionsRenderer.setMap(map);
    },

    deleteOrigin(index) {
      this.origin.pop(index);
    },
    deleteDestination(index) {
      this.destination.pop(index);
    },
    drawTransit() {
      var directionsService = new google.maps.DirectionsService();
      var directionsRenderer = new google.maps.DirectionsRenderer();

      var map = new google.maps.Map(this.$refs["map"]);

      var request = {
        origin: this.findA,
        destination: this.findB,
        travelMode: "TRANSIT",
      };

      directionsService
        .route(request, (result, status) => {
          if (status === "OK") {
            directionsRenderer.setDirections(result);
            directionsRenderer.setMap(null);
            directionsRenderer.setMap(map);
            this.isDraw = true;
          }
        })
        .catch((error) => {
          console.log(error);
        });
    },
    drawDriving() {
      var directionsService = new google.maps.DirectionsService();
      var directionsRenderer = new google.maps.DirectionsRenderer();

      var map = new google.maps.Map(this.$refs["map"]);

      var request = {
        origin: this.findA,
        destination: this.findB,
        travelMode: "DRIVING",
      };

      directionsService
        .route(request, (result, status) => {
          if (status === "OK") {
            directionsRenderer.setDirections(result);
            directionsRenderer.setMap(null);
            directionsRenderer.setMap(map);
            this.isDraw = true;
          }
        })
        .catch((error) => {
          console.log(error);
        });
    },

    carRoad() {
      this.car = [];
      this.transits = [];
      const url = `https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${this.start}&destination=place_id:${this.end}&key=*YourServiceKey*&mode=DRIVING&alternatives=true`;

      axios.get(url).then((response) => {
        // console.log(response.data.routes);

        let routes = response.data.routes;
        routes.forEach((route) => {
          route.legs[0].distance.text;
          route.legs[0].duration.text;
          this.car.push({
            distance: route.legs[0].distance.text,
            duration: route.legs[0].duration.text,
          });
        });
      });
    },

    byTrans() {
      this.drive = "bus";
    },

    byCar() {
      this.drive = "drive";
    },

    checkTrans() {
      if (this.drive === "bus") {
        this.findRoad();
      } else {
        this.drive = "drive";
        this.carRoad();
      }
    },

    findRoad() {
      this.car = [];
      this.transits = [];
      const url = `https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${this.start}&destination=place_id:${this.end}&mode=transit&key=*YourServiceKey*&alternatives=true`;

      axios
        .get(url)
        .then((response) => {
          const result = response.data;
          if (result.status === "OK") {
            let temp = result.routes;

            temp.forEach((route) => {
              let transit = [];
              let road = route.legs[0].steps;
              let distance = [];
              let duration = [];
              let html_instructions = [];
              var totalDis = route.legs[0].distance.text;
              var totalDur = route.legs[0].duration.text;

              road.forEach((info) => {
                var dis = info.distance.text;
                var dur = info.duration.text;
                var html = info.html_instructions;

                distance.push(dis);
                duration.push(dur);
                html_instructions.push(html);
              });

              transit.push({
                totalDis: totalDis,
                totalDur: totalDur,
                distance: distance,
                duration: duration,
                html_instructions: html_instructions,
                show: false,
                start: this.findA,
                end: this.findB,
              });
              this.transits.push(transit);
            });
            console.log(this.transits);
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },

    centerMap(latitude, longitude, event) {
      if (event !== undefined){
          event.preventDefault();
      }      
      if (this.isDraw) {
        this.map = new google.maps.Map(this.$refs["map"], {
          zoom: 15,
          center: new google.maps.LatLng(this.curX, this.curY),
        });
        new google.maps.Marker({
          position: new google.maps.LatLng(this.curX, this.curY),
          animation: google.maps.Animation.DROP,
          map: this.map,
        });
        this.isDraw = false;
      }

      this.searchX = latitude;
      this.searchY = longitude;

      for (let i = 0; i < this.greenMarkers.length; i++) {
        this.greenMarkers[i].setMap(null);
      }
      this.greenMarkers = [];

      if (this.searchX !== this.curX && this.searchY !== this.curY) {
        const marker = new google.maps.Marker({
          position: new google.maps.LatLng(this.searchX, this.searchY),
          map: this.map,
          icon: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
        });
        this.greenMarkers.push(marker);
      }
      const center = new google.maps.LatLng(latitude, longitude);
      this.map.setCenter(center);
    },

    search(e) {
      e.preventDefault();
      switch (this.identifier) {
        case "place":
          this.placeSearch();
          break;
        case "nearby":
          this.nearBySearch();
          break;
        case "road":
          this.checkTrans();
          break;
        case "route":
          // this.checkRoute();
          break;
        case "air":
          this.findAir();
          break;
        default:
          this.placeSearch();
          break;
      }
    },
    findAir() {
      fetch("https://test.api.amadeus.com/v1/security/oauth2/token", {
        body: "grant_type=client_credentials&client_id=*YourServiceKey*&client_secret=*YourServiceKey*",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        method: "POST",
      })
        .then((response) => response.json()) // 첫 번째 then에서 응답을 JSON 형식으로 파싱
        .then((data) => {
          console.log(data);
          const token = data.access_token; // 3. 응답에서 토큰 추출
          console.log(token);
          console.log(this.airStartDate);
          console.log(this.airStartTime);
          // 4. 항공권 정보 요청
          const url = "https://test.api.amadeus.com/v2/shopping/flight-offers";
          const requestData = {
            currencyCode: "KRW", // 통화 코드 (예: KRW)
            originDestinations: [
              {
                id: "1",
                originLocationCode: this.departureAirport, // 출발지 코드 (예: ICN)
                destinationLocationCode: this.arrivalAirport, // 도착지 코드 (예: NRT)
                departureDateTimeRange: {
                  date: this.airStartDate, // 출발 날짜 (예: 2023-06-06)
                  time: this.airStartTime, // 출발 시간 (예: 10:00:00)
                },
              },
            ],
            travelers: [
              {
                id: "1",
                travelerType: "ADULT", // 여행자 유형 (예: ADULT)
              },
            ],
            sources: ["GDS"], // 데이터 소스 (예: GDS)
            searchCriteria: {
              maxFlightOffers: 20, // 최대 항공권 결과 수 (예: 10)
              flightFilters: {
                cabinRestrictions: [
                  {
                    cabin: this.seat,
                    coverage: "MOST_SEGMENTS",
                    originDestinationIds: ["1"],
                  },
                ],
              },
            },
          };
          // 5. 항공권 정보 요청
          return fetch(url, {
            method: "POST",
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify(requestData),
          });
        })
        .then((response) => response.json()) // 6. 응답을 JSON 형식으로 파싱
        .then((data) => {
          // console.log(data); // 반환된 데이터를 원하는 방식으로 처리
          let airInfo = data;

          let start = this.departureAirport;
          let end = this.arrivalAirport

          for (let i = 0; i < this.airports.length; i++) {
          if (this.airports[i].code === this.departureAirport) {
            start = this.airports[i].name;
            break;
          }
        }

        for (let i = 0; i < this.airports.length; i++) {
          if (this.airports[i].code === this.arrivalAirport) {
            end = this.airports[i].name;
            break;
          }
        }

          
          for (var i = 0; i < data.meta.count; i++) {
            let info = data.data[i];
            // console.log(info);
            let detail = info.itineraries[0].segments[0];
            // let validatingAirlineCodes = info.validatingAirlineCodes[0];

            let carrierCode = airInfo.dictionaries.carriers[detail.carrierCode];
            let price = parseInt(info.price.total);
            let numberOfBookableSeats = info.numberOfBookableSeats;
            let departure = detail.departure.at;
            let arrival = detail.arrival.at;
            let numberOfStops = detail.numberOfStops;


            let airInfos = [
              {
                departure,
                arrival,
                price,
                carrierCode,
                numberOfBookableSeats,
                numberOfStops,
                start,
                end
              },
            ];
            this.planes.push(airInfos);
          }
          console.log(this.planes);
        })
        .catch((error) => {
          console.error(error);
        });
    },

    findHotel() {
      this.clearMarkers();

      this.hotels = [];
      const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=호텔&location=${this.searchX},${this.searchY}&radius=3000&key=*YourServiceKey*`;
      console.log(url);
      console.log(this.searchX);
      console.log(this.searchY);
      axios.get(url).then((reponse) => {
        var temp = reponse.data.results;
        var idx = 0;
        temp.forEach((place) => {
          http.get(`/plan/api/photo/${place.place_id}`).then((response) => {
            const photos = response.data;
            const url =
              "https://maps.googleapis.com/maps/api/place/photo?maxwidth=40&photoreference=" +
              photos.photo +
              "&key=*YourServiceKey*";
            place.photo = url;
            // this.places.push(place);
            axios
              .get(
                `https://maps.googleapis.com/maps/api/place/details/json?key=*YourServiceKey*&place_id=` +
                  place.place_id
              )
              .then((res) => {
                var t = res.data.result;
                console.log(t.url);
                place.url = t.url;
                this.hotels.push(place);

                // 마커 추가
                const marker = new google.maps.Marker({
                  position: new google.maps.LatLng(
                    place.geometry.location.lat,
                    place.geometry.location.lng
                  ),
                  map: this.map,
                  icon: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                });

                marker.addListener("click", () => {
                  const infowindow = new google.maps.InfoWindow({
                    content: `<div><strong>${place.name}</strong><br>${place.vicinity}<br><a href="${place.url}" target="_blank">링크</a></div>`,
                  });
                  infowindow.open(this.map, marker);
                });

                this.markers.push(marker);
              });
          });
        });
      });
    },

    placeSearch() {
      this.clearMarkers();
      this.places = [];
      const keyword = encodeURIComponent(this.title);
      const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?key=*YourServiceKey*&query=${keyword}`;

      axios
        .get(url)
        .then((response) => {
          // console.log(response);
          var temp = response.data.results;
          // this.places = reponse.data.results;
          if (temp.length > 0) {
            var idx = 0;
            temp.forEach((place) => {
              http.get(`/plan/api/photo/${place.place_id}`).then((response) => {
                const photos = response.data;
                const url =
                  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=40&photoreference=" +
                  photos.photo +
                  "&key=*YourServiceKey*";
                place.photo = url;
                // this.places.push(place);
                axios
                  .get(
                    `https://maps.googleapis.com/maps/api/place/details/json?key=*YourServiceKey*&place_id=` +
                      place.place_id
                  )
                  .then((res) => {
                    var t = res.data.result;
                    console.log(t.url);
                    place.url = t.url;
                    this.places.push(place);

                    // 마커 추가
                    const marker = new google.maps.Marker({
                      position: new google.maps.LatLng(
                        place.geometry.location.lat,
                        place.geometry.location.lng
                      ),
                      map: this.map,
                      icon: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                    });

                    marker.addListener("click", () => {
                      const infowindow = new google.maps.InfoWindow({
                        content: `<div><strong>${place.name}</strong><br>${place.vicinity}<br><a href="${place.url}" target="_blank">링크</a></div>`,
                      });
                      infowindow.open(this.map, marker);
                    });

                    this.markers.push(marker);
                  });
              });
            });
          }
          if (temp.length > 0) {
            const firstPlace = temp[0];
            const latLng = new google.maps.LatLng(
              firstPlace.geometry.location.lat,
              firstPlace.geometry.location.lng
            );
            this.map.setCenter(latLng);
          }
        })
        .catch((error) => {
          // 에러가 발생한 경우 대체 문구를 설정합니다.
          console.error(error);
        });
    },

    nearBySearch() {
      // event.preventDefault();
      this.clearMarkers();

      this.places = [];
      const keyword = encodeURIComponent(this.title);
      const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${keyword}&location=${
        this.searchX
      },${this.searchY}&radius=${
        this.radius * 1000
      }&key=*YourServiceKey*`;
      axios.get(url).then((reponse) => {
        var temp = reponse.data.results;
        // this.places = reponse.data.results;
        var idx = 0;
        temp.forEach((place) => {
          http.get(`/plan/api/photo/${place.place_id}`).then((response) => {
            const photos = response.data;
            const url =
              "https://maps.googleapis.com/maps/api/place/photo?maxwidth=40&photoreference=" +
              photos.photo +
              "&key=*YourServiceKey*";
            place.photo = url;
            // this.places.push(place);
            axios
              .get(
                `https://maps.googleapis.com/maps/api/place/details/json?key=*YourServiceKey*&place_id=` +
                  place.place_id
              )
              .then((res) => {
                var t = res.data.result;
                console.log(t.url);
                place.url = t.url;
                this.places.push(place);

                // 마커 추가
                const marker = new google.maps.Marker({
                  position: new google.maps.LatLng(
                    place.geometry.location.lat,
                    place.geometry.location.lng
                  ),
                  map: this.map,
                  icon: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                });

                marker.addListener("click", () => {
                  const infowindow = new google.maps.InfoWindow({
                    content: `<div><strong>${place.name}</strong><br>${place.vicinity}<br><a href="${place.url}" target="_blank">링크</a></div>`,
                  });
                  infowindow.open(this.map, marker);
                });

                this.markers.push(marker);
              });
          });
        });
      });
    },
    clearMarkers() {
      for (let i = 0; i < this.markers.length; i++) {
        this.markers[i].setMap(null);
      }
      this.markers = [];
    },

    makePlan(place) {
      this.plans.push(place);
    },

    makeAir(plane) {
      this.resPlane.push(plane);
    },
    deleteAir(plane, event) {
      event.preventDefault();
      event.stopPropagation();
      const index = this.resPlane.indexOf(plane);
      if (index > -1) {
        this.resPlane.splice(index, 1);
      }
    },
    deleteAddRoute(index, event) {
      event.preventDefault();
      event.stopPropagation();
      // const index = this.addRoute.indexOf(route);
      if (index > -1) {
        this.addRoute.splice(index, 1);
      }
    },
    deleteTimeRoute(route, event) {
      event.preventDefault();
      event.stopPropagation();
      const index = this.timeRoute.indexOf(route);
      if (index > -1) {
        this.timeRoute.splice(index, 1);
      }
    },
    deleteDisRoute(route, event) {
      event.preventDefault();
      event.stopPropagation();
      const index = this.disRoute.indexOf(route);
      if (index > -1) {
        this.disRoute.splice(index, 1);
      }
    },
    deleteResRoute(index, event){
      event.preventDefault();
      event.stopPropagation();
      // console.log(route)
      // const index = this.resRoute.indexOf(route);
      if (index > -1) {
        this.resRoute.splice(index, 1);
      }
    },

    deletePlan(plan, event) {
      event.preventDefault();
      event.stopPropagation();
      const index = this.plans.indexOf(plan);
      if (index > -1) {
        this.plans.splice(index, 1);
      }
    },

    submitForm() {
      
      const formData = {
        user_id: this.user_id,
        start_date: this.start_date,
        end_date: this.end_date,
        title: this.plan_title,
        plans: this.plans,
        content: this.content,
        plan_id: this.plan_id,
        routes : this.resRoute,
        planes : this.resPlane,
        store: "YES",
        // 기타 다른 필요한 데이터
      };
      
      http.put("/plan/api", formData).then((response) => {
        console.log(response.data);
      });
    },
    sendFormData() {
      if (this.plan_id) {
        const formData = {
          start_date: this.start_date,
          end_date: this.end_date,
          title: this.plan_title,
          plans: this.plans,
          content: this.content,
          plan_id: this.plan_id,
          routes : this.resRoute,
          planes : this.resPlane,
          store: "NO",

          // 기타 다른 필요한 데이터
        };

        http.put("/plan/api", formData).then((response) => {
          console.log(response.data);
        });
      } else {
        const formData = {
          user_id: this.user_id,
          start_date: this.start_date,
          end_date: this.end_date,
          title: this.plan_title,
          plans: this.plans,
          content: this.content,
          routes : this.resRoute,
          planes : this.resPlane,
          store: "NO",
          // 기타 다른 필요한 데이터
        };
        http.post("/plan/api", formData).then((response) => {
          console.log(response.data);
          var id = response.data;
          this.plan_id = id.plan_id;
        });
      }
    },

    checkPlace(e) {
      e.preventDefault();
      this.identifier = "place";
    },
    checkNearBy(e) {
      e.preventDefault();
      this.identifier = "nearby";
    },
    checkRoad(e) {
      e.preventDefault();
      this.identifier = "road";
      this.initRoad().then(() => {
        // 초기화 작업 완료 후 실행할 코드
      });
    },
    checkRoute(e) {
      e.preventDefault();
      this.identifier = "route";
      this.initAdd().then(() => {
        // 초기화 작업 완료 후 실행할 코드
      });
    },
    checkAir(e) {
      e.preventDefault();
      this.identifier = "air";
    },
    checkHotel(e) {
      e.preventDefault();
      this.identifier = "hotel";
      this.findHotel();
    },

    initAdd() {
      return new Promise((resolve) => {
        this.$nextTick(() => {
          let startAutocomplete = new google.maps.places.Autocomplete(
            this.$refs["add"],
            {
              bounds: new google.maps.LatLngBounds(),
            }
          );

          startAutocomplete.addListener("place_changed", () => {
            let place = startAutocomplete.getPlace();
            console.log(place);
            let formatted_address = place.formatted_address;
            let place_id = place.place_id;
            let urll = place.url;

            http.get(`/plan/api/photo/${place.place_id}`).then((response) => {
              console.log(response);
              const photos = response.data;
              const url =
                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=40&photoreference=" +
                photos.photo +
                "&key=*YourServiceKey*";
              place.photo = url;

              axios
                .get(
                  `https://maps.googleapis.com/maps/api/place/details/json?key=*YourServiceKey*&place_id=` +
                    place.place_id
                )
                .then((res) => {
                  var t = res.data.result;
                  let temp = {
                    formatted_address,
                    place_id,
                    url: urll,
                    photo: url,
                    lat: t.geometry.location.lat,
                    lng: t.geometry.location.lng,
                  };
                  console.log(temp);
                  this.addRoute.push(temp);
                });
            });
          });
          resolve();
        });
      });
    },

    initRoad() {
      return new Promise((resolve) => {
        this.$nextTick(() => {
          let currentLocation = new google.maps.LatLng(
            this.searchX,
            this.searchY
          );
          let geocoder = new google.maps.Geocoder();
          geocoder.geocode({ location: currentLocation }, (results, status) => {
            if (status === "OK" && results[0]) {
              let currentAddress = results[0].formatted_address;
              console.log(currentAddress);
              this.findA = currentAddress;
              this.start = results[0].place_id;
              resolve();
            }
          });

          let startAutocomplete = new google.maps.places.Autocomplete(
            this.$refs["start"],
            {
              bounds: new google.maps.LatLngBounds(),
            }
          );

          startAutocomplete.addListener("place_changed", () => {
            let place = startAutocomplete.getPlace();
            console.log(place.formatted_address);
            this.findA = place.formatted_address;
            this.start = place.place_id;
          });

          let endAutocomplete = new google.maps.places.Autocomplete(
            this.$refs["end"],
            {
              bounds: new google.maps.LatLngBounds(),
            }
          );

          endAutocomplete.addListener("place_changed", () => {
            let place = endAutocomplete.getPlace();
            console.log(place.formatted_address);
            this.findB = place.formatted_address;
            this.end = place.place_id;
          });

          resolve();
        });
      });
    },
  },
};
</script>

<style>
.flex-container {
  display: flex;
  flex-direction: column;
}

.flex-row {
  display: flex;
}
.custom-button {
  flex: 1;
  background-color: rgb(118, 232, 255);
  color: rgb(124, 122, 122);
  padding: 10px;
  margin: 5px;
  border: solid;
  border-radius: 5px;
}
</style>
