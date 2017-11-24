# 카카오톡 챗봇

1. [플러스친구 관리자 센터](https://yellowid.kakao.com/)

   - 새플러스친구 만들기
   - 플러스친구 이름은 변경할 수 있다. 
   - 검색용 아이디는 바꿀 수 없으니 주의

2. [c9 프로젝트 생성]

   ```ruby
   rails g controller kakao keyboard message
   ```

   ```ruby
   # app/controllers/kakao_controller.rb  
   def keyborad
       
       keyborad = {
         :type => "buttons",
         :buttons => ["선택 1", "선택 2", "선택 3"]
       }
       render json: keyborad
    end
   ```

   ```ruby
   # routes.rb
     get '/keyboard' => 'kakao#keyborad'
   ```

   ##### Specification

   - **Method** : GET
   - **URL** : http(s)://:your_server_url/keyboard
   - **Content-Type** : application/json; charset=utf-8
   - **예제**

3. [플러스친구]

   * c9의 주소를 url에 붙인다.
   * API 테스트 
   * ​

4. [카카오톡 플러스친구 github](https://github.com/plusfriend/auto_reply)

   * 5.1 참고 Home Keyboard API

5. 대답할 수 있도록 만들기 
   5.2<br>Specification

   - **Method** : POST

   - **URL** : http(s)://:your_server_url/message

   - **Content-Type** : application/json; charset=utf-8

   - **Parameters**

     > 카카오톡 서버랑 대화하는 것이 된다. Post기능을 추가한다. 

     ```ruby
     post '/message' => 'kakao#message'
     ```

   - 우선 메아리 챗봇을 구현

   ```ruby
    def keyboard
          # 메아리 chatbot
       keyboard = {
         type: "text"
       }
         render json: keyboard
     end  
      
     def message
       user_msg = params[:content]
       result = {
       "message"=>{
           "text"=>"user_msg"
       }
   }
     render json: result
       
   ```

6. [로또, 메뉴 ]

   ```ruby
   class KakaoController < ApplicationController
     def keyboard
       keyboard = {
         :type => "buttons",
         buttons: ["로또", "메뉴", "고양이"]
       }
       render json: keyboard
     end

     def message
       user_msg = params[:content]
       
       if user_msg == "로또"
         msg = (1..46).to_a.sample(6).to_s
       elsif user_msg == "메뉴"
         msg = ["편의점", "김밥카페", "서브웨이"].sample
       else
         msg = "아직 지원하지 않는 서비스입니다."
       end
       
       
       result = {
         :message => {
           text: msg
         }
       }
       render json: result
     end
   end
   ```

   ​

7. [Cat API](http://thecatapi.com/)

8. 리턴결과가 중요하다. 

   * response

   * 따라서 result안에 message는 꼭 있어야 한다. 

     ```
     {
         "message":{
             "text" : "귀하의 차량이 성공적으로 등록되었습니다. 축하합니다!"
         }
     }
     {
       "message": {
         "text": "귀하의 차량이 성공적으로 등록되었습니다. 축하합니다!",
         "photo": {
           "url": "https://photo.src",
           "width": 640,
           "height": 480
         },
         "message_button": {
           "label": "주유 쿠폰받기",
           "url": "https://coupon/url"
         }
       },
       "keyboard": {
         "type": "buttons",
         "buttons": [
           "처음으로",
           "다시 등록하기",
           "취소하기"
         ]
       }
     }
     ```

     | 필드명      | 타입                                       | 필수여부     | 설명                                       |
     | -------- | ---------------------------------------- | -------- | ---------------------------------------- |
     | message  | [Message](https://github.com/plusfriend/auto_reply/blob/master/README.md#62-message) | Required | 자동응답 명령어에 대한 응답 메시지의 내용. 6.2에서 상세 기술     |
     | keyboard | [Keyboard](https://github.com/plusfriend/auto_reply#6-object) | Optional | 키보드 영역에 표현될 명령어 버튼에 대한 정보. 생략시 text 타입(주관식 답변 키보드)이 선택된다. 6.1에서 상세 기술 |

     ​
     message는 필수로 들어가고 다른것은 선택사항이다. 

```ruby
     result = {
      :message => {
        text: msg
      }
    }
```

```ruby
      message = {
        text: msg
      }
      
  
    result = {
      :message => message
      }
    }
```

```ruby
     message = {
        text: msg
      }
      
      message_photo = {
        text: "냐옹",
        photo: {
          url: cat_url, 
          width: 640,
          height: 480
          
        }
      }
  
    if user_msg == "고양이"
      result = {
        message: message_photo,
      }
    else
      result = {
        message: message
      }
    
    end
    
    render json: result
  end
```

```ruby
class KakaoController < ApplicationController
  def keyboard
    keyboard = {
      :type => "buttons",
      buttons: ["로또", "메뉴", "고양이"]
    }
    render json: keyboard
  end

  def message
    require 'nokogiri'
    require 'rest-client'
    user_msg = params[:content]
    
    if user_msg == "로또"
      msg = (1..46).to_a.sample(6).to_s
    elsif user_msg == "메뉴"
      msg = ["편의점", "김밥카페", "서브웨이"].sample
    elsif user_msg == "고양이"
      cat_xml = RestClient.get 'http://thecatapi.com/api/images/get?format=xml&results_per_page=1&type=jpg'
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text
    else
      msg = "아직 지원하지 않는 서비스입니다."
    end
  
      message = {
        text: msg
      }
      
      message_photo = {
        text: "냐옹",
        photo: {
          url: cat_url, 
          width: 640,
          height: 480
          
        }
      }
  
    if user_msg == "고양이"
      result = {
        message: message_photo,
      }
    else
      result = {
        message: message
      }
    
    end
    
    render json: result
  end
end


```





# 배포

```ruby
# 변경전
#gem 'sqlite3'
# 변경후
gem 'sqlite3', :group => :development
gem 'pg', :group => :production
gem 'rails_12factor', :group => :production
```

config/database.yml



데이터베이스를 안쓰는 경우 heroku는 문제가 없다. 

```ruby
$ heroku login
Enter your Heroku credentials:

$ heroku create
Creating app... done, ⬢ polar-retreat-14650
https://polar-retreat-14650.herokuapp.com/ | https://git.heroku.com/polar-retreat-14650.git

$ git push heroku master

```

https://polar-retreat-14650.herokuapp.com/ | https://git.heroku.com/polar-retreat-14650.git



