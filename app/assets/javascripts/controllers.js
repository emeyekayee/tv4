'use strict';

// ============================================================================
// Hi-lock: ((" [T]TD.*"                                      (0 'accent10 t)))
// Hi-lock: (("\\(^\\|\\W\\)\\*\\(\\w.*\\w\\)\\*\\(\\W\\|$\\)" (2 'accent3 t)))
// Hi-lock: end
// ============================================================================

// Don't repeat the same calculation.
function filter_justify_tweaks(sc) {
  var scrollLeft  = sc.scrollLeft()
  if ( filter_justify_tweaks.old_srcoll == scrollLeft ) return
  filter_justify_tweaks.old_srcoll = scrollLeft
  do_justify_tweaks( sc, scrollLeft )
}


function do_justify_tweaks (sc, scrollLeft) {
  $('.TimeheaderDayNightrow .timespan').each( function() { // Centered
    justify( scrollLeft, $(this).children() )
  });

  // $('.RuleSchedulerow .timespan').each( function() {       // Centered
  //   justify( scrollLeft, $(this).children() )
  // });

  $('.Stationrow .timespan').each( function() {            // Left-aligned
    justify_left( scrollLeft, $(this).children() )
  });

  // $('.Storyrow .timespan').each( function() {              // Left-aligned
  //   justify_left( scrollLeft, $(this).children() )
  // });
}


function may_straddle (scrollLeft, scrollRight, blockdivs) {
  var divs = [], bdiv, cd;
  var len = blockdivs.length;

  for (var i = 0;
       (i<len) && (cd = common_data(blockdivs[i])) && cd.bdiv_right < scrollLeft;
       i++) {}

  for (;
       (i<len) && (bdiv= blockdivs[i]) && parseInt(bdiv.style.left) < scrollRight;
       i++) {
    divs.push( bdiv )
  }
  return divs
}

// function sort_em (divs) {
//   divs.sort( function(a, b) {
//     return parseInt(a.style.left) - parseInt(b.style.left)
//   })
// }


//////////////////////////////////////////////////////////////////////////////
// Re-align left-aligned block content (typ. Channelrows)

function justify_left (scrollLeft, blockdivs) {
  // sort_em( blockdivs )

  var scrollRight = scrollLeft + TimePix.pixWindow,
      bdivs       = may_straddle (scrollLeft, scrollRight, blockdivs);  
  if (! bdivs.length) {return}

  var cd = common_data( bdivs[0] )
  if ( cd.bdiv_left < scrollLeft  ) {
    bdivs.shift()
    justify_left_1 ( scrollLeft,  cd );
  }
  undo_any_justify_left( bdivs );
}

function justify_left_1 ( scrollLeft, cd ) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollLeft ) {
    var jleft  = scrollLeft - cd.bdiv_left

    // cd.tl.css('left', jleft + 'px')
    cd.tl.animate({left: jleft}, rand_speed())
  }
}

function undo_any_justify_left (bdivs) {
  bdivs.forEach( function( bdiv ) {
    // $('.text_locator', bdiv).css( 'left', '')
    var tl = $('.text_locator', bdiv)
    if ( parseInt(tl.css('left')) == 2 ) {return}
    tl.animate({ left: "2" }, rand_speed())
  })
}

function rand_speed() { return { duration: 400 + Math.random() * 400 } }

//////////////////////////////////////////////////////////////////////////////
// Re-align center-aligned block content.
 
function justify (scrollLeft, blockdivs) {
  // sort_em(blockdivs)
  var scrollRight = scrollLeft + TimePix.pixWindow,
      bdivs       = may_straddle (scrollLeft, scrollRight, blockdivs);
  if (! bdivs.length) {return}

  if ( straddles(scrollLeft, bdivs[0]) && straddles(scrollRight, bdivs[0]) ) {
    straddles_both( scrollLeft, scrollRight, common_data(bdivs[0]) )
  } else {

    while ( bdivs.length > 0 && straddles( scrollLeft, bdivs[0] ) ) {
      straddles_left  (scrollLeft,  common_data(bdivs.shift()));
    }

    while ( bdivs.length > 0 && straddles( scrollRight, bdivs.slice(-1)[0] ) ) {
      straddles_right( scrollRight, common_data(bdivs.pop()) );
    }

    bdivs.forEach( function(bdiv) {
      straddles_none(               common_data(bdiv));
    })
  }
}

function straddles(edge, bdiv) {
  var cd = common_data( bdiv )
  return ( cd.bdiv_left < edge && edge < cd.bdiv_right )
}

function common_data(bdiv) {
  var left  = parseInt(bdiv.style.left)
  var width = parseInt(bdiv.style.width)
  return { tl:         $('.text_locator', bdiv),
           bdiv_left:  left,
           bdiv_width: width,
           bdiv_right: left + width }
}

function straddles_both (scrollLeft, scrollRight, cd) {
  var  nleft = scrollLeft  - cd.bdiv_left
  var nwidth = scrollRight - scrollLeft
  relocate (cd.tl,  nleft, nwidth)
}

function straddles_right (scrollRight, cd) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollRight ) {
    var room = scrollRight - parseInt( cd.tl.parent().css('left') )
    var jwidth = Math.max( room, 190 ) // 15 in vp
    relocate (cd.tl,     0, jwidth)
  }
}

function straddles_left (scrollLeft, cd) {
  if ( cd.bdiv_left + cd.bdiv_width > scrollLeft ) {
    var room = parseInt( cd.tl.parent().css('width') )
    var jleft  = Math.min (scrollLeft - cd.bdiv_left, room - 190 ) // 15 in vp
    var jwidth = room - jleft           // Should calculate  ^^^ this Fix Me
    relocate (cd.tl, jleft, jwidth)
  }
}

function straddles_none(cd) {
  var room = parseInt( cd.tl.parent().css('width') )
  if ( parseInt(cd.tl.css('left'))  != 0 ||
       parseInt(cd.tl.css('width')) != room ) {
    relocate (cd.tl,    0, room)
  }
}


function relocate (tl, nleft, nwidth) {
  tl.animate({opacity: 0}, {queue: true, duration: 200})
  tl.animate({ left: nleft, width: nwidth}, {queue: true, duration: 0})
  tl.animate({opacity: 1}, {queue: true, duration: 800})
}
  // tl.css(  'left',   nleft + 'px' ) 
  // tl.css( 'width',  nwidth + 'px' )
  // $tl.fadeIn({duration: 800})
  // $(tl).stop().animate({ left: nleft, width: nwidth}, {duration: 800}) 
  // 'fast' { queue: true, duration: 200 }

//////////////////////////////////////////////////////////////////////////////

/* Controllers */

function ResourceListCtrl($scope, $http) {
  $.extend( $scope,
    {
      init_display_parms: function () {
        TimePix.set_display_parms()
      },

      init_resources: function () {    
        $scope.init_display_parms()
        
        $scope.rsrcs    = UseBlock.rsrcs = TimePix.meta.rsrcs
        $scope.res_tags = [];   // ^^ Defines the order of rows
        $scope.rsrcs.forEach( function(rsrc) {
          $scope.res_tags.push( rsrc.tag )
        })
        $scope.use_block_list_Ctls = {} // To access lower-level scopes later on

        setTimeout( TimePix.scroll_to_tlo, 100 )
        setTimeout( TimePix.set_time_cursor, 1000 )
        setTimeout( TimePix.scroll_monitor, 100 )
      },

      get_data: function (t1, t2, inc) {
        return $http.get( $scope.make_url(t1, t2, inc) ).

          success( function(data) {
            TimePix.merge_metadata(data)
            delete data.meta
            $scope.json_data = data   // Park this here until we consume it.

             if (! inc) { $scope.init_resources($scope) }
            $scope.busy = false;
          }). // success

          error( function(data, status, headers, config) {
            console.log( '\nstatus: ' + status +
                         '\nheaders(): ' + headers() +
                         '\nconfig: ' + config
                        )
            console.debug( data.meta )
            $scope.busy = false;
          }) // error
      },

      make_url: function (t1, t2, inc) {
        var url = '/schedule.json'
        if (t1 || t2 || inc)
          url += '?t1=' + t1 + '&t2=' + t2 + '&inc=' + inc
        return url
      },

      rq_data: function(t1, t2, inc) {
        if (! $scope.busy ) {
          $scope.busy = true;
          $scope.get_data( t1, t2, inc ).
            success( function(data) {
              Object.keys($scope.json_data).forEach( function(key) {
                var controller = $scope.use_block_list_Ctls[key] // TTD: 2.1 Blows here
                if( ! controller ) {
                  console.log( "No key " + key + " in " +
                               $scope.use_block_list_Ctls );
                  return
                }
                var blocks     = $scope.json_data[key]
                controller.add_blocks( controller, blocks ) // TTD: 2.0 Blows here
              })
            }); // errors handled above in get_data
        }
      },
      
      more_data: function() {
          $scope.rq_data( TimePix.thi, TimePix.next_hi(), 'hi' )
      },

      less_data: function() {
          $scope.rq_data( TimePix.next_lo(), TimePix.tlo, 'lo' )
      }
    });
  window.RsrcListCtrlScope = $scope
  $scope.get_data();
} // end ResourceListCtrl
ResourceListCtrl.$inject = ['$scope', '$http'];


function ab (o) { return angular.bind( o, o.process ) }

var process_fns = {
  TimeheaderDayNight: ab(TimeheaderDayNightUseBlock),
  TimeheaderHour:     ab(TimeheaderHourUseBlock),
  Station:            ab(StationUseBlock)
  // Channel:            ab(ChannelUseBlock),
  // RuleSchedule:       ab(RuleScheduleUseBlock),
  // Story:              ab(StoryUseBlock),
  // State:              ab(StateUseBlock)
}


function UseBlockListCtrl($scope) {

  $.extend( $scope, {

    add_blocks: function ( $scope, blocks ) {
      var how = 'push'
      if (TimePix.inc == 'lo') {
        how = 'unshift'
        blocks.reverse()
      }                        
      if( ! blocks ) { return }
      blocks.forEach( function(block) { // TTD: Blows up here 0
        $scope.insert_block( $scope.process_fn(block.blk), how )
      })
    },

    insert_block: function ( block, how ) {
      $scope.use_blocks[how]( block )
    }
  });


  $scope.use_blocks = [];

  var resourceTag = $scope.res_tag,
      blocks      = $scope.json_data[ resourceTag ],
      rsrc_kind   = resourceTag.split('_')[0];

  $scope.process_fn = process_fns[rsrc_kind];
  if (! $scope.process_fn) {
    console.log( 'Skipping use blocks with tag ' + resourceTag )
    return null
  }

  $scope.use_block_list_Ctls[resourceTag] = $scope

  $scope.add_blocks( $scope, blocks )
}
UseBlockListCtrl.$inject = ['$scope']; // TTD: Blows up here 1 (vp)


function UseBlockCtrl($scope) {
  var block = $scope.block // Just for debugger
}
UseBlockCtrl.$inject = ['$scope'];


function LabelListCtrl($scope) {
  var tag = $scope.res_tag
  UseBlock.rsrcs[tag] // Huh?
}
LabelListCtrl.$inject = ['$scope'];

