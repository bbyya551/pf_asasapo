/* global $*/
// $(document).on('turbolinks:load', function () {
//   console.log("読み込まれました");
//   $(window).on('scroll', function() {
//     scrollHeight = $(document).height();
//     scrollPosition = $(window).height() + $(window).scrollTop();
//     if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
//           $('.jscroll').jscroll({
//             contentSelector: '.scroll-list',
//             nextSelector: 'a[rel=next]:last'
//           });
//     }
//   });
// });

$(document).on('turbolinks:load', function () {
  // console.log("location.href");
  // console.log(location.href.match(/chats/));
  // console.log("location.href");

  if ( location.href.match(/chats/)) {
    //strにhogeを含む場合の処理
    let elm = document.documentElement;
    let bottom = elm.scrollHeight - elm.clientHeight;
    window.scroll(0, bottom);
  }

});


//   $(document).ready(function () {
//     $("#theTarget").skippr({
//       // スライドショーの変化 ("fade" or "slide")
//       transition : 'slide',
//       // 変化に係る時間(ミリ秒)
//       speed : 1000,
//       // easingの種類
//       easing : 'easeOutQuart',
//       // ナビゲーションの形("block" or "bubble")
//       navType : 'block',
//       // 子要素の種類('div' or 'img')
//       childrenElementType : 'div',
//       // ナビゲーション矢印の表示(trueで表示)
//       arrows : true,
//       // スライドショーの自動再生(falseで自動再生なし)
//       autoPlay : true,
//       // 自動再生時のスライド切替間隔(ミリ秒)
//       autoPlayDuration : 3000,
//       // キーボードの矢印キーによるスライド送りの設定(trueで有効)
//       keyboardOnAlways : true,
//       // 一枚目のスライド表示時に戻る矢印を表示するかどうか(falseで非表示)
//       hidePrevious : false
//     });
//   });
// });