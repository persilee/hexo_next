<!DOCTYPE html>

<!--
                           _ooOoo_
                          o8888888o
                          88" . "88
                          (| -_- |)
                          O\  =  /O
                       ____/`---'\____
                     .'  \\|     |//  `.
                    /  \\|||  :  |||//  \
                   /  _||||| -:- |||||-  \
                   |   | \\\  -  /// |   |
                   | \_|  ''\---/''  |   |
                   \  .-\__  `-`  ___/-. /
                 ___`. .'  /--.--\  `. . __
              ."" '<  `.___\_<|>_/___.'  >'"".
             | | :  `- \`.;`\ _ /`;.`/ - ` : | |
             \  \ `-.   \_ __\ /__ _/   .-` /  /
        ======`-.____`-.___\_____/___.-`____.-'======
                           `=---='
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                 佛祖保佑       永无BUG  By:- lishaoy.net
-->

{% set html_class = 'theme-next ' + theme.scheme %}
{% if theme.use_motion %}
  {% set html_class = html_class + ' use-motion' %}
{% endif %}

<html class="{{ html_class | lower }}" lang="{{ config.language }}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>
  {% include '_third-party/analytics/index.swig' %}
  {# 优化
  <link href="//cdn.jsdelivr.net/gh/moezx/cdn@v2.52/css/lib.css" rel="stylesheet" type="text/css">
  <link href="/css/lib.css" rel="stylesheet" type="text/css">
  <link href="/lib/fancybox/source/jquery.fancybox.css" rel="stylesheet" type="text/css">
  <link href="/lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="/css/main.css" rel="stylesheet" type="text/css">
  <link href="/live2dw/css/perTips.css" rel="stylesheet" type="text/css">
  #}
  <link href="https://cdn.lishaoy.net/all-257b1803f3.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://cdn.lishaoy.net/css/video-js.css">
</head>

<body itemscope itemtype="http://schema.org/WebPage" lang="{{ page.lang || page.language || config.language }}">

  <div id="loader">
    <div></div>
  </div>

  {% set container_class = "container " %}
  {% if theme.sidebar.position %}
    {% set container_class = container_class + 'sidebar-position-' + theme.sidebar.position %}
  {% endif %}

  <div class="{{ container_class }} {% block page_class %}{% endblock %} ">
    <div class="headband"></div>
    <a href="https://github.com/persilee" class="github-corner" aria-label="View source on Github"><svg width="80" height="80" viewBox="0 0 250 250" style="fill:#151513; color:#fff; position: absolute; top: 0; border: 0; left: 0; transform: scale(-1, 1);" aria-hidden="true"><path d="M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z"></path><path d="M128.3,109.0 C113.8,99.7 119.0,89.6 119.0,89.6 C122.0,82.7 120.5,78.6 120.5,78.6 C119.2,72.0 123.4,76.3 123.4,76.3 C127.3,80.9 125.5,87.3 125.5,87.3 C122.9,97.6 130.6,101.9 134.4,103.2" fill="currentColor" style="transform-origin: 130px 106px;" class="octo-arm"></path><path d="M115.0,115.0 C114.9,115.1 118.7,116.5 119.8,115.4 L133.7,101.6 C136.9,99.2 139.9,98.4 142.2,98.6 C133.8,88.0 127.5,74.4 143.8,58.0 C148.5,53.4 154.0,51.2 159.7,51.0 C160.3,49.4 163.2,43.6 171.4,40.1 C171.4,40.1 176.1,42.5 178.8,56.2 C183.1,58.6 187.2,61.8 190.9,65.4 C194.5,69.0 197.7,73.2 200.1,77.6 C213.8,80.2 216.3,84.9 216.3,84.9 C212.7,93.1 206.9,96.0 205.4,96.6 C205.1,102.4 203.0,107.8 198.3,112.5 C181.9,128.9 168.3,122.5 157.7,114.1 C157.9,116.9 156.7,120.9 152.7,124.9 L141.0,136.5 C139.8,137.7 141.6,141.9 141.8,141.8 Z" fill="currentColor" class="octo-body"></path></svg><style>.github-corner:hover .octo-arm{animation:octocat-wave 560ms ease-in-out}@keyframes octocat-wave{0%,100%{transform:rotate(0)}20%,60%{transform:rotate(-25deg)}40%,80%{transform:rotate(10deg)}}@media (max-width:500px){.github-corner:hover .octo-arm{animation:none}.github-corner .octo-arm{animation:octocat-wave 560ms ease-in-out}}</style></a>

    <header id="header" class="header" itemscope itemtype="http://schema.org/WPHeader">
      <div class="header-inner"> {%- include '_partials/header.swig' %} </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div class="content-wrap">
          <div id="content" class="content">
          {% if is_home() %}
            <div class="status_list_item icon_kyubo">
              <div class="status_user" style="background-image: url(https://cdn.lishaoy.net/image/112131.jpg);">
                <div class="status_section">
                  <a href="http://lishaoy.net/" class="status_btn" target="_blank">通知</a>
                  <p class="section_p">从2020年5月01日起，所有项目及文章的动态都会放到 <a href="https://lishaoy.net/update/" target="_blank" style="color: rgba(255, 87, 34, 0.92);">动态更新</a> 页面，方便大家查看</p>
                  <p class="section_p">也欢迎大家光临我的主站! 😜 <a href="https://lishaoy.net/" target="_blank" style="color: rgba(255, 87, 34, 0.92);">https://lishaoy.net</a></p>
                </div>
			        </div>
		        </div>
          {% endif %}
            {% block content %}{% endblock %}
          </div>
          {% include '_third-party/duoshuo-hot-articles.swig' %}
          {% if page.type == '' %}
            {% include '_partials/comments.swig' %}
          {% elseif page.type != '' %}
            {% include '_partials/comments_no_post.swig' %}
          {% endif %}
        </div>
        {% if theme.sidebar.display !== 'remove' %}
          {% block sidebar %}{% endblock %}
        {% endif %}
      </div>
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
        {% include '_third-party/analytics/busuanzi-counter.swig' %}
        {% block footer %}{% endblock %}
      </div>
    </footer>

    {% if not theme.sidebar.b2t %}
      <div class="back-to-top">
        <i class="fa fa-arrow-up"></i>
        {% if theme.sidebar.scrollpercent %}
          <span id="scrollpercent"><span>0</span>%</span>
        {% endif %}
      </div>
    {% endif %}

  </div>

  {% include '_scripts/vendors.swig' %}
  {% include '_scripts/commons.swig' %}

  {% set scheme_script = '_scripts/schemes/' + theme.scheme | lower + '.swig' %}
  {% include scheme_script %}

  {% block script_extra %}
    {% include '_scripts/pages/post-details.swig' %}
  {% endblock %}

  {% include '_scripts/boostrap.swig' %}

  {% include '_third-party/comments/index.swig' %}
  {% include '_third-party/search/index.swig' %}
  {% include '_third-party/analytics/lean-analytics.swig' %}
  {% include '_third-party/seo/baidu-push.swig' %}
  {% include '_third-party/rating.swig' %}
  {% include '_third-party/mathjax.swig' %}
  {% include '_third-party/scroll-cookie.swig' %}
  {% include '_third-party/exturl.swig' %}

  <div id="load" style=""></div>
  <!-- 新增看娘
  <script async src="/live2dw/js/perTips.js"></script>
  <script src="/live2dw/lib/L2Dwidget.min.js"></script>
  -->

  <!-- 页面点击小红心
  <script type="text/javascript" src="/js/src/love.js"></script>
  -->

  <!-- 背景动画
  <script type="text/javascript" src="/js/src/particle.js"></script>
  -->

   <!-- 输入爆炸效果来自 http://xiaowiba.com （小尾巴） 如有侵权，请通知我撤销
  <script type="text/javascript" src="/js/src/activate-power-mode.js"></script>
  -->

   <!-- UV、PV统计
  <script async src="https://cdn.lishaoy.net/js/busuanzi.pure.mini.js"></script>
  -->

  <script type="text/javascript" src="https://cdn.lishaoy.net/js/all-min-d98fa596b6.js"></script>
  <script src="https://cdn.lishaoy.net/js/video-js.js"></script>


   <!-- 自己的脚本
  <script type="text/javascript" src="/js/src/persilee.js"></script>
  -->
  <script> $(function(){ $('#loader').css('display','none');});</script>
  <!--   google统计
  <script async src="https://www.googletagmanager.com/gtag/js?id=UA-120619444-1"></script>  -->
<style>
    @font-face{
      font-family: Pacifico;
      src: url("//cdn.lishaoy.net/font/Pacifico.ttf");
    }
    .site-title {
      font-family: 'Pacifico', 'Lobster Two', 'Lato', "PingFang SC", "Microsoft YaHei", sans-serif;
    }
    .comments.no-post {
      background: transparent;
    }
    .no-post.v *{
      color: #fff;
    }

    table {
      table-layout: auto;
    }

    .posts-expand .post-body>table  {
        table-layout: auto;
    }

    img {
      backface-visibility: hidden;
    }

    .video-js {
      max-width: -webkit-fill-available;
      max-width: 850px;
    }

    .video {
      position: relative;
      padding-bottom: 69.66%;
      height: 0;
      overflow: hidden;
    }
    .video iframe,
    .video object,
    .video embed {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
    }

    .no-post.v::-webkit-input-placeholder{
      color: #eee;
    }
    .v .vlist p {
      margin: 12px 0;
    }
    .v .vbtn {
      background: #fbfbfb;
      padding: .3rem 1.2em;
      border: 1px solid #dddddd75;
    }
    .no-post.v .vbtn {
      background: #2222220a;
    }
    .no-post.v .vbtn:active, .no-post.v .vbtn:hover {
      color: rgba(255, 87, 34, 0.86);
      border-color: rgba(255, 87, 34, 0.9);
      background-color: #fff;
    }
    .post-toc .nav .active-current > a:hover {
      color: rgba(255, 87, 34, 0.86);
    }
    .no-post.v .vwrap {
      border: 1px solid #f0f0f036;;
    }
    .no-post.v a {
      color: #fff;
    }
    .v ul {
      padding-left: 25px;
    }
    .v ul li {
      list-style: disc;
      padding: 2px 15px 0 0;
    }
    .v .vlist strong , .vinput.vpreview strong {
        color: #87daff;
        font-size: 108%;
    }
    .v .vlist .vcard .vhead .vsys {
        background: rgba(255, 87, 34, 0.06);
        color: rgba(96, 125, 139, 0.45);
        border: 1px solid #87daff1f;
        padding: 1px 5px;
        font-size: 12px;
        line-height: 1.4;
    }

    .no-post.v .vlist .vcard .vhead .vsys{
      background: rgba(255, 255, 255, 0.36);
      color: rgba(121, 85, 72, 0.56);
      padding: 1px 5px;
      font-size: 12px;
      line-height: 1.4;
      border: none;
    }

    .no-post.v .vlist .vcard .vcontent a {
      color: #fffffff2;
      border-bottom-color: #ccc;
    }

    .v .vlist .vcard .vcontent a:hover {
        color: #607D8B;
        border-bottom-color: #607D8B;
    }

    .no-post.v .vlist .vcard section {
        border-bottom: 1px dashed #f5f5f55e;
    }

    .no-post.v .vlist .vcard section .vfooter .vtime {
        color: #eee;
    }

    .v .vlist .vcard section .vfooter .vtime {
        color: #9E9E9E;
    }

    .v .vwrap .vheader .vinput {
        width: 33.33%;
        border-bottom: 1px dashed #dedede45;
    }
    .no-post.v .vwrap .vheader .vinput::-webkit-input-placeholder, .no-post.v .vwrap .vedit .vinput::-webkit-input-placeholder {
        color: #eee;
    }
    .no-post.v .vwrap .vheader .vinput:-ms-input-placeholder, .no-post.v .vwrap .vedit .vinput::-webkit-input-placeholder{  /* Internet Explorer 10-11 */
        color: #eee;
    }


    .no-post.v .vcontrol .col {
        color: #eee;
    }
    .v .txt-right {
        display: none;
    }

    .v .vlist .vcard .vcontent .code, .v .vlist .vcard .vcontent code, .v .vlist .vcard .vcontent pre , .vinput.vpreview code , .vinput.vpreview pre {
      color: #ff5722;
      background: rgba(244,67,54,0.26);
      border-radius: 2px;
      box-shadow: 0 0 2px rgba(255,87,34,0.36);
      font-size: 86%;
      padding: 1px 4px;
    }
    .v .vbtn:active, .v .vbtn:hover {
      color: #FF5722;
      border-color: #FF5722;
      background-color: #fff;
    }
    .v .vlist .vcard .vcontent img {
      display: inline-block;
    }

    .v .vwrap .vheader .vinput:focus {
      border-bottom: 1px solid #ffffff6e;
    }
    .v .vlist .vcard .vcontent pre , .vinput.vpreview pre {
        background: #87daff21;
        border-radius: 4px;
        box-shadow: 0 0 2px #ffffff33;
    }
    .v .vlist .vcard .vcontent pre code ,.vinput.vpreview pre code {
        color: #005098e3;
        background: #87daff00;
        border-radius: 4px;
        box-shadow: 0 0 2px #87daff05;
    }
    .comments.no-post .vlist .vcard .vcontent pre code , .comments.no-post .vinput.vpreview pre code {
        color: #7fd3f9;
    }
    .v .vlist .vcard .vcontent.expand:after {
      color: #ff0000de;
      font-size: 110%;
      font-weight: bold;
      background: #87daff38;
      border-bottom-right-radius: 4px;
      border-bottom-left-radius: 4px;
    }
    .comments.no-post .vlist .vcard .vcontent.expand:after {
      color: #fff;
    }
    @media screen and (max-width: 414px) {
        .v .vlist {
            padding-left: 0;
        }
    }
    @media screen and (max-width: 520px) {
      .v .vlist .vcard .vhead .vsys {
        display: inline-block;
      }
    }
    .v .vlist .vcard .vcontent.expand:before {
        background: linear-gradient(180deg,hsla(0, 0%, 100%, 0),hsla(199, 100%, 76%, 0.22));
        background: -webkit-gradient(linear,left top,left bottom,from(hsla(0,0%,100%,0)),to(hsla(199, 100%, 76%, 0.22));
    }
</style>

</body>
</html>
