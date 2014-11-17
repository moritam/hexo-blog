moon-metro
==========
Moon-Metro is  a flat, minimal and responsive theme for Hexo, it is developed based on Metro-light

[Demo](http://blog.mugbya.cn)

## 更改如下

- 修改字体
- 在右边的widget 实现文章目录(TOC)


### TOC实现

1. 首先在widget 下添加toc挂件

        widgets:
        - search
        - toc
        - recent_posts
        - category
        - tag

2. 在主题下的 /layout/_widget/新建 toc.ejs 文件, 并添加如下代码

        <% if(!page.excerpt) { %>
        <% }  else { %>
                <% if(page.toc != false){%>
                    <div class="toc">
                        <%- "<h2> 文章目录 </h2> " %>
                        <%-  toc(page.content) %>
                    </div>
                <% } %>
        <% } %>

3. 修改主题。

 在/source/css/_partial/sidebar.styl 添加css样式


