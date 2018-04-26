$(function () {

   // 调整 github logo 大小
   $('.github-corner svg').width(60).height(60);

  POWERMODE.colorful = true; // ture 为启用礼花特效
  POWERMODE.shake = false; // false 为禁用震动特效
  document.body.addEventListener('input', POWERMODE);

  //让 header 适应 暗色 背景
  $('#header').addClass('dark').addClass('animated');
  $('.sidebar-toggle').on('click',function(){
      $('#header').toggleClass('header-has-sidebar');
  });

  // 鼠标往上滚动 隐藏 header , 鼠标往下滚动 显示 header
  $(document).on("mousewheel DOMMouseScroll", function (e) {
    var delta = (e.originalEvent.wheelDelta && (e.originalEvent.wheelDelta > 0 ? 1 : -1)) ||  // chrome & ie
      (e.originalEvent.detail && (e.originalEvent.detail > 0 ? -1 : 1));              // firefox
    if (delta > 0) {
      // 向上滚
      $('#header').removeClass('slideOutUp').addClass('slideInDown');
    } else if (delta < 0) {
      // 向下滚
      if ($(window).scrollTop() > 10) {
          $('#header').addClass('slideOutUp').removeClass('slideInDown');
      }
    }
  });

  // 给页面新增滚动进度条
  function scroll_fn() {
    var document_height = $(document).height();
    var scroll_so_far = $(window).scrollTop();
    var window_height = $(window).height();
    var max_scroll = document_height - window_height;
    var scroll_percentage = scroll_so_far / (max_scroll / 102);
    $('#load').width(scroll_percentage + '%');

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
    if ($(window).width() <= 990){
      $('#header').removeClass('header-has-sidebar');
    } else if ($('#sidebar').width() > 0){
      $('#header').addClass('header-has-sidebar');
    }
  });

  setTimeout(() => {
    $('.vhead .vname[href="https://lishaoy.net"]').after('<span class = "bozhu">博主</span>');
  }, 500);

  $('.vsubmit.vbtn').on('click',function(){
    setTimeout(() => {
      console.log('aaa');
      if (!$('.vhead').eq(0).find('.vname[href="https://lishaoy.net"]~.bozhu')){
        $('.vhead').eq(0).find('.vname[href="https://lishaoy.net"]').after('<span class = "bozhu">博主</span>');
      }

    }, 1000);
  });


});



