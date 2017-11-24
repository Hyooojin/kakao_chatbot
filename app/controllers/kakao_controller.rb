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
      
      basic_keyboard = {
        type: "buttons",
        buttons: ["로또", "메뉴", "고양이"]
      }
  
    if user_msg == "고양이"
      result = {
        message: message_photo,
        keyboard: basic_keyboard
      }
    else
      result = {
        message: message,
        keyboard: basic_keyboard
      }
    
    end
    
    render json: result
  end
end