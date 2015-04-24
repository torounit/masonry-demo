<!doctype html>
<html lang="ja">
<head>
	<meta charset="UTF-8">
	<title>masonry demo</title>
	<link rel="stylesheet" href="assets/dist/styles/all.css"/>
</head>
<body>

<div class="container">

	<div class="tiles">
		<div class="size"></div>

		<?php for($i = 0; $i < 50; $i ++):?>

			<?php
			$class = "";
			$rand = rand( 0, 20 );
			if($rand < 1) {
				$class = "tile_dobule-w tile_dobule-h";
			}
			elseif($rand < 3) {
				$class = "tile_dobule-w";
			}
			elseif($rand < 5) {
				$class = "tile_dobule-h";
			}
			?>

			<div class="tile <?=$class;?>">
				<div class="tile__content"></div>
			</div>

		<?php endfor;?>

	</div>


</div>


<script src="assets/dist/scripts/all.js"></script>
</body>
</html>