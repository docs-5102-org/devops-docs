import { defineUserConfig } from "vuepress";
import theme from "./theme.js";



export default defineUserConfig({
  base: "/",

  lang: "zh-CN",
  title: "tuonioooo's DevOps Docs",
  description: "一个高效的运维文档",
  // 在head中添加meta标签，支持访问微信图片
  head: [
    ['meta', { name: 'referrer', content: 'no-referrer' }],
    // 其他meta标签...
  ],
  theme,
 
  // 和 PWA 一起启用
  // shouldPrefetch: false,
});
