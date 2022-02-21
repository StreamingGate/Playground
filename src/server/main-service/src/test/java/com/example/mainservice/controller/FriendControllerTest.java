package com.example.mainservice.controller;

import com.example.mainservice.dto.FriendDto;
import com.example.mainservice.entity.User.User;
import com.example.mainservice.service.FriendService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/* @WebMvcTest : WebApplication 관련된 Bean들만 등록하기 때문에 통합 테스트보다 빠르다. */
@ExtendWith(SpringExtension.class)
@WebMvcTest(controllers = FriendController.class)
public class FriendControllerTest {

    private static final String REQUEST_PREFIX = "/friends/";
    private static final String TARGET_MAP_KEY = "target";
    private static final String RESPONSE_MAP_KEY = "result";
    private static final String[] USER_UUID = new String[]{
            "",
            "11111111-1234-1234-123456789012",
            "22222222-1234-1234-123456789012",
            "33333333-1234-1234-123456789012",
            "44444444-1234-1234-123456789012"
    };
    private final ObjectMapper mapper = new ObjectMapper();

    @Autowired
    private MockMvc mockMvc; // 서블릿 컨테이너 모칭. 톰캣 서버 구동 없이 실행.

    @MockBean
    private FriendService friendService;

    @DisplayName("유저3의 모든 친구 리스트 조회")
    @Test
    public void getFriendListTest() throws Exception {
        //given
        FriendDto fakeUser1 = createFriendDto(1l);
        FriendDto fakeUser4 = createFriendDto(4l);
        List<FriendDto> fakeFriendDtoList = new ArrayList<>(){{add(fakeUser1); add(fakeUser4);}};
        String result = createResponse(fakeFriendDtoList);

        //mocking
        given(friendService.getFriendList(USER_UUID[3])).willReturn(fakeFriendDtoList);

        // when
        final ResultActions actions = mockMvc.perform(get(REQUEST_PREFIX + USER_UUID[3]));

        //then
        actions.andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json(result))
                .andDo(print());
    }

    @DisplayName("유저2가 유저3에게 친구 요청")
    @Test
    public void requestFriendTest() throws Exception {
        //given
        Map<String, String> targetMap = Map.of(TARGET_MAP_KEY, USER_UUID[3]);
        String targetMapString = mapper.writeValueAsString(targetMap);
        String result = createResponse(USER_UUID[3]);

        //mocking
        given(friendService.requestFriend(USER_UUID[2], USER_UUID[3])).willReturn(USER_UUID[3]);

        //when
        final ResultActions actions = mockMvc.perform(post(REQUEST_PREFIX + USER_UUID[2])
                .contentType(MediaType.APPLICATION_JSON)
                .content(targetMapString));

        //then
        actions.andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json(result));
    }

    @DisplayName("유저3이 유저2의 친구요청 수락")
    @Test
    public void allowFriendRequestTest() throws Exception {
        //given
        Map<String, String> targetMap = Map.of(TARGET_MAP_KEY, USER_UUID[2]);
        String targetMapString = mapper.writeValueAsString(targetMap);
        String result = createResponse(USER_UUID[2]);

        //mocking
        given(friendService.allowFriendRequest(USER_UUID[3], USER_UUID[2])).willReturn(USER_UUID[2]);

        //when
        final ResultActions actions = mockMvc.perform(post(REQUEST_PREFIX + "manage/"+ USER_UUID[3])
                .contentType(MediaType.APPLICATION_JSON)
                .content(targetMapString));

        //then
        actions.andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json(result));
    }

    @DisplayName("유저3이 유저2의 친구요청 거절")
    @Test
    public void refuseFriendRequestTest() throws Exception {
        //given
        Map<String, String> targetMap = Map.of(TARGET_MAP_KEY, USER_UUID[2]);
        String targetMapString = mapper.writeValueAsString(targetMap);
        String result = createResponse(USER_UUID[2]);

        //mocking
        given(friendService.refuseFriendRequest(USER_UUID[3], USER_UUID[2])).willReturn(USER_UUID[2]);

        //when
        final ResultActions actions = mockMvc.perform(delete(REQUEST_PREFIX + "manage/" + USER_UUID[3])
                .contentType(MediaType.APPLICATION_JSON)
                .content(targetMapString));

        //then
        actions.andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json(result));
    }

    @DisplayName("유저3가 유저1을 친구 삭제")
    @Test
    public void deleteFriendTest() throws Exception {
        //given
        Map<String, String> targetMap = Map.of(TARGET_MAP_KEY, USER_UUID[1]);
        String targetMapString = mapper.writeValueAsString(targetMap);
        String result = createResponse(USER_UUID[1]);

        //mocking
        given(friendService.deleteFriend(USER_UUID[3], USER_UUID[1])).willReturn(USER_UUID[1]);

        //when
        final ResultActions actions = mockMvc.perform(delete(REQUEST_PREFIX + USER_UUID[3])
                .contentType(MediaType.APPLICATION_JSON)
                .content(targetMapString));

        //then
        actions.andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json(result));
    }

    private FriendDto createFriendDto(Long id){
        return new FriendDto(USER_UUID[id.intValue()], "nick"+id.toString(),
                "profileImage"+id.toString());
    }

    private User createUser(Long id){
        return User.builder()
                .id(id)
                .uuid(USER_UUID[id.intValue()])
                .nickName("nick"+ id.toString())
                .profileImage("profileImage"+id.toString())
                .build();
    }

    private String createResponse(Object object) {
        String result = null;
        try{
            result = mapper.writeValueAsString(Map.of(RESPONSE_MAP_KEY, object));
        } catch(JsonProcessingException e){
            e.printStackTrace();
        }
        return result;
    }
}
