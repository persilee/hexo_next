$(function () {

  //新增看娘
  var jsonPaths = ['/live2dw/assets/hijiki.model.json', '/live2dw/assets/tororo.model.json'];
  var jsonPath = jsonPaths[Math.round(Math.random())];
  var opacityDefault = 0;
  if ($(window).width() <= 1024) {
    opacityDefault = 1;
  }else{
    opacityDefault = 0.8;
  }
  L2Dwidget.init({
    "pluginRootPath": "live2dw/",
    "pluginJsPath": "lib/",
    "pluginModelPath": "assets/",
    "model": {
      "jsonPath": jsonPath,
    },
    "display": {
      "superSample": 1.8,
      "position": "left",
      "width": 90,
      "height": 220,
      "hOffset": 8,
      "vOffset": -126
    },
    "mobile": {
      "show": true,
      "scale": 0.5
    },
    "react": {
      "opacityDefault": opacityDefault,
      "opacityOnHover": 0.2
    }
  });

  // 调整 github logo 大小
  $('.github-corner svg').width(60).height(60);

  POWERMODE.colorful = true; // ture 为启用礼花特效
  POWERMODE.shake = false; // false 为禁用震动特效
  document.body.addEventListener('input', POWERMODE);

  //让 header 适应 暗色 背景
  $('#header').addClass('dark').addClass('animated');
  $('.sidebar-toggle').on('click', function () {
    $('#header').toggleClass('header-has-sidebar');
  });

  $('.popup-trigger.faa-parent.animated-hover').on('click',function(){
    $('.github-corner').hide();
    $('.sidebar-toggle').hide();
    $('.back-to-top.back-to-top-on').hide();
    $('#sidebar').hide();
    $('#header').removeClass('slideInDown');
    $('.local-search-popup .local-search-header').addClass('search-middle');
  });
  $('.popup-btn-close').on('click',function(){
    $('.github-corner').show();
    $('.sidebar-toggle').show();
    $('#sidebar').show();
    $('.back-to-top.back-to-top-on').show();
  })
  $('#local-search-input').on('change keydown',function(){
    $('.local-search-popup .local-search-header').removeClass('search-middle');
  });

  // 鼠标往上滚动 隐藏 header , 鼠标往下滚动 显示 header
  var p = 0,
      t = 0;
  $(document).on("scroll", function (e) {
    p = $(this).scrollTop();

    if (t <= p) { //下滚
      if ($(window).scrollTop() > 10) {
        $('#header').addClass('slideOutUp').removeClass('slideInDown');
      }
      if ($(window).scrollTop() == $(document).height() - $(window).height()) showMessage('喵~ 页面到底了，点击右下角箭头 ⬆️ ，可回到顶部', 3000);
    } else { //上滚
      $('#header').removeClass('slideOutUp').addClass('slideInDown');
    }
    setTimeout(function () {
      t = p;
    }, 0);
  });

  // 给页面新增滚动进度条
  function scroll_fn() {
    var document_height = $(document).height();
    var scroll_so_far = $(window).scrollTop();
    var window_height = $(window).height();
    var max_scroll = document_height - window_height;
    var scroll_percentage = scroll_so_far / (max_scroll / 102);
    $('#load').width(scroll_percentage + '%');
    if (scroll_percentage >= 100){
      $('#load').hide();
    }else{
      $('#load').show();
    }
    var document_width = $(document).width();
    if (scroll_so_far > 5) {
      $('#header').addClass('light-header').removeClass('dark');
    } else {
      $('#header').removeClass('light-header').addClass('dark');
    }
  }
  $(window).scroll(function () {
    scroll_fn();
  });
  $(window).resize(function () {
    scroll_fn();
    if ($(window).width() <= 990) {
      $('#header').removeClass('header-has-sidebar');
    } else if ($('#sidebar').width() > 0) {
      $('#header').addClass('header-has-sidebar');
    }
  });

  setTimeout(() => {
    var text;
    $('.vhead .vname[href="https://lishaoy.net"]').after('<span class = "bozhu">博主</span>');
    $('#live2d-widget').prepend('<div class="per-tips"></div >');

    if (jsonPath == '/live2dw/assets/hijiki.model.json')
      text = '喵~ 我是 <span style="color:#fdb9b9">hijiki<i style="font-size:18px;">&nbsp;🐱</i></span> </br>'
    else
      text = '喵~ 我是 <span style="color:#fdb9b9">tororo<i style="font-size:18px;">&nbsp;🐱</i></span> </br>'
    ;
    if (document.referrer !== '' && document.referrer !== 'https://lishaoy.net/') {
      var referrer = document.createElement('a');
      referrer.href = document.referrer;
      var domain = referrer.hostname.split('.')[1];
      if (referrer.hostname == 'lishaoy.net'){
        text += '欢迎来到&nbsp;<span style="color:#0099cc;">『' + document.title.split(' | ')[0] + '』</span>,感谢您继续参观本站 🙂';
      }else if (domain == 'baidu') {
        text += '来自 百度搜索 的朋友<br>你是搜索 <span style="color:#0099cc;">' + referrer.search.split('&wd=')[1].split('&')[0] + '</span> 找到的我吗？';
      } else if (domain == 'so') {
        text += '来自 360搜索 的朋友<br>你是搜索 <span style="color:#0099cc;">' + referrer.search.split('&q=')[1].split('&')[0] + '</span> 找到的我吗？';
      } else if (domain == 'google') {
        text += '来自 谷歌搜索 的朋友<br>欢迎阅读<span style="color:#0099cc;">『' + document.title.split(' - ')[0] + '』</span>';
      }
    } else if (localStorage.getItem('ValineCache') !== ('' || null) && window.location.href == 'https://lishaoy.net/'){
      text += '<span style="color:#0099cc;"><strong>&nbsp;' + JSON.parse(localStorage.getItem('ValineCache')).nick + '&nbsp;</strong></span>欢迎回来！要继续看 👀 些什么吗';
    } else {
      if (window.location.href == 'https://lishaoy.net/') { //如果是主页
        var now = (new Date()).getHours();
        if (now > 23 || now <= 5) {
          text += '你是夜猫子呀？这么晚还不睡觉，明天起的来嘛';
        } else if (now > 5 && now <= 7) {
          text += '早上好！一日之计在于晨，美好的一天就要开始了';
        } else if (now > 7 && now <= 11) {
          text += '上午好！工作顺利嘛，不要久坐，多起来走动走动哦！';
        } else if (now > 11 && now <= 14) {
          text += '中午了，工作了一个上午，现在是午餐时间！';
        } else if (now > 14 && now <= 17) {
          text += '午后很容易犯困呢，今天的运动目标完成了吗？';
        } else if (now > 17 && now <= 19) {
          text += '傍晚了！窗外夕阳的景色很美丽呢，最美不过夕阳红~';
        } else if (now > 19 && now <= 21) {
          text += '晚上好，今天过得怎么样？';
        } else if (now > 21 && now <= 23) {
          text += '已经这么晚了呀，早点休息吧，晚安~';
        } else {
          text += '快来逗我玩吧！';
        }
      } else {
        text = '欢迎阅读<span style="color:#0099cc;">『' + document.title.split(' | ')[0] + '』</span>';
      }
    }
    showMessage(text, 6000);
  }, 2000);

  $('.vsubmit.vbtn').on('click', function () {
    setTimeout(() => {
      if ($('.vhead').eq(0).find('.vname[href="https://lishaoy.net"]~.bozhu')) {
        $('.vhead').eq(0).find('.vname[href="https://lishaoy.net"]').after('<span class = "bozhu">博主</span>');
      }
    }, 1000);
  });
});
