/* global $*/
// $(document).on('turbolinks:load', function () {
//   console.log("読み込まれました");
//   $(window).on('scroll', function() {
//     scrollHeight = $(document).height();
//     scrollPosition = $(window).height() + $(window).scrollTop();
//     if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
//           $('.jscroll').jscroll({
//             contentSelector: '.scroll-list',
            // 'a[rel=next]:last'は、htmlのページネーションのclassはどれも同じだった。nextボタンのみ、何か指定してやる必要があり、nextボタンには、rel = nextが指定されていたので、それをNextSelecterとして指定した。
//             nextSelector: 'a[rel=next]:last'
//           });
//     }
//   });
// });
// 遷移するとき、差分を読み込んでいるだけなので、この記述(turbolinks:load)がないと動作しない。
$(document).on('turbolinks:load', function () {
  // console.log("location.href");
  // console.log(location.href.match(/chats/));
  // console.log("location.href");

  // https://mebee.info/2020/11/23/post-17840/
  // https://uxmilk.jp/9205
  // https://qiita.com/kazu56/items/557740f398e82fc881df
  // if ( str.match(/hoge/)) ⇦ここの例で言うと、str = location.hrefを代入してもいい。
  // location.hrefでurlを取得してきて、その中にchatsが含まれるかと言う意味。
  if ( location.href.match(/chats/)) {
    //strにhogeを含む場合の処理
    let elm = document.documentElement;
    // scrollHeight ページの高さ clientHeight ブラウザの高さ
    let bottom = elm.scrollHeight - elm.clientHeight;
    // 垂直方向へ移動window.scroll( 数値(水平) , 数値(垂直) ) ;
    window.scroll(0, bottom);
  }
});

$(document).on('turbolinks:load', function () {
  $('#tab-contents .tab[id != "tab1"]').hide();

  $('#tab-menu a').on('click', function(event) {
    $("#tab-contents .tab").hide();
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    event.preventDefault();
  });
});