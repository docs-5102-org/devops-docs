import { navbar } from "vuepress-theme-hope";

export default navbar([
  "/",
  { text: "Linux", icon: "codicon:terminal-linux", link: "/linux/"},
  // 将 Docker 相关链接合并为下拉菜单
  {
    text: 'Docker',
    icon: 'skill-icons:docker',
    children: [
      { text: 'Gitbook Docker', link: 'https://tuonioooo-notebook.gitbook.io/docker' },
      { text: 'Github Docker', link: 'https://github.com/tuonioooo/docker' },
    ],
  },
  {
    text: '脚本',
    icon: 'fa6-solid:code',
    children: [
      { text: 'bat', link: '/script/bat/bat-starter' },
      { text: 'lua', link: '/script/lua/lua-starter' },
      { text: '油猴', link: '/script/tampermonkey/tampermonkey-starter' },
    ],
  },
  {
    text: '📘 专项文档',
    children: [
      { text: '💻 服务端语言', link: 'https://coding.dzspace.top/' },
      {
        text: '📜 AI智能化文档',
        link: 'https://notion.dzspace.top',
      },
    ]
  }
]);
