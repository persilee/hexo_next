<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>
<div class="powered-by">
  <i class="fa fa-users fa-fw"></i>
  <span id="busuanzi_container_site_uv">
    终于等到你(UV): <span id="busuanzi_value_site_uv"></span>
  </span>
  &nbsp;&nbsp;|&nbsp;&nbsp;
  <i class="fa fa-bar-chart-o fa-fw"></i>
  <span id="busuanzi_container_site_pv">
    欢迎再来(PV): <span id="busuanzi_value_site_pv"></span>
  </span>

  <div class="theme-info">
    <div class="powered-by"></div>
    <span class="post-count">Blog总字数: {{ totalcount(site) }}字</span>
  </div>
</div>

<!--
{% if theme.copyright %}

<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io">Hexo</a>') }}
</div>

<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
    NexT.{{ theme.scheme }}
  </a>
</div>
{% endif %}
-->
