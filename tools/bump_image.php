#!/usr/bin/php
<?
$im = imagecreatefrompng($argv[1]);
list($width, $height, $type, $attr) = getimagesize($argv[1]);

$maxx=0 ;
$minx=0 ;
$maxy=0 ;
$miny=0 ;

$diffx = array() ;
$diffy = array();
$diviseur = 1;

for ( $y = 1 ; $y < $height-1 ; $y++){
  for ( $x = 1; $x < $width-1 ; $x++){
    
    $c1 =  imagecolorsforindex($im, imagecolorat($im, $x-1, $y)) ;
    $c2 =  imagecolorsforindex($im, imagecolorat($im, $x+1, $y)) ;

    $c = (int)  (($c1['red']-$c2['red']) / $diviseur) ;
    $diffx[] = $c ;

    $maxx = max($maxx, $c) ;
    $minx = min($minx, $c) ;

    $c1 =  imagecolorsforindex($im, imagecolorat($im, $x, $y-1)) ;
    $c2 =  imagecolorsforindex($im, imagecolorat($im, $x, $y+1)) ;

    $c = (int) (($c1['red']-$c2['red']) / $diviseur) ;
    $diffy[] =  $c ;

    $maxy = max($maxy, $c) ;
    $miny = min($miny, $c) ;

 

  }
}

echo '; Maxx ', $maxx, ' - Minx', $minx, "\n" ;
echo '; Maxy ', $maxy, ' - Miny', $miny, "\n" ;
echo '; Les quatres  bits poid fort sont le decalage en X', "\n" ;
echo '; Les quatres suivants, le decalage en Y', "\n" ;
echo ';', count($diffx),' octets', "\n" ; 

for($pos = 0; $pos<count($diffx) ; $pos++){
#  $val = abs($diffx[$pos])*2^4 + abs($diffy[$pos]) ;

  $val1 = $diffx[$pos]  ;
  $val2 = $diffy[$pos]  ;

  if ($pos%10 ==0)
    echo "\n DB\t$val1,$val2" ;
  else
    echo ",$val1,$val2" ;



}

echo "\n; $pos octets ajoutes" ;
echo "\n; $width x $height" ;
echo '; Maxx ', $maxx, ' - Minx', $minx, "\n" ;
echo '; Maxy ', $maxy, ' - Miny', $miny, "\n" ;
?>
