	;***************************************************
	;//何もしないブートプログラム
	;***************************************************
	jmp $					;while(1);//長調ループ
	times 510 - ($ - $$) db 0x00
	db 0x55,0xAA

	;(関数の概要())
	; 1.名前通り何もしないブートプログラムなのですごくすごくすごくすごくすごく長いループを作って
	;		やります、「jmp $ 」の$の意味は今実行しているアドレスです、実際にアセンブルするとEBEF
	;		というマシン語が出来上がりますEBはjmp命令でEFとはいうと２進数で11111110つまり１０進数
	;		でー２を表しています、どうやらjmp命令にはこのようなアドレス指定もできるらしくて？だからIPレ
	;		ジスタの値も-２されるわけで同じアドレスのjmp命令を繰り返すことになり結果的にループができ
	;		あがります、2バイトの命令です
	; 2.BIOSによって最初にメモリに展開されるプログラムは512バイト+終端2バイトが0x55,0xAAである
	;   必要があるので必要に応じて0を書き込むnasmの疑似命令です,times疑似命令は指定された回数分、
	;　　後続の命令を繰り返します、今回の例では (510回 - 命令バイト分) で１バイトずつ0で埋めるこ
	;		とで合計512ばいとのでーたをつくります、510 - ($ - $$) の意味としては,$は現在の実行番地
	;		$$はセクションの一番先頭です、セクションの一番先頭というのは(ここから勝手なので注意)ですね
	;		例として今このテキストファイルに書いているコード以外に変数や関数が存在する場合アセンブルを
	;		行うときに必然的に出力されるバイナリデータも変わってきますよね、なので$が指し示すアドレス
	;		も変わります、$はアセンブルした時に決定する値であって実際にアセンブルした時に結果を得ること
	;		ができます、つまりソースコードのアレコレで変わる'不定値'ということです、それでは510 - $
	; 	として引数を渡したらどうなるのかというと、error: non-constant argument supplied to
	;   TIMES というエラーを伝えてきます、結果から言うとtimes疑似命令には'定数'を引数として渡し
	;		てやる必要があります、今回の510 - $ の場合こちらは不定値になります「どこから数えればいいの
	;		！？」「変数とか関数は含めるの？？」みたいな感じかな？そこで活用するのが$$です、さっきの
	;		通りに$$の意味はセクションの先頭、つまりここに書いているソースコードの先頭です、「セクション
	;		の始から**番目だよ」って感じかな、これでどこのアドレスかはっきりしました、このセクションの
	;		先頭から初めて3バイト目、だと思います、これで定数を要求するtimes疑似命令に応えられました
	;		ポイントはセクション同士の結合で現在のアドレス(ローケーションカウンタ)が変わりうるということ
	;		です、ですので$$というセクションの開始位置という情報を付随してやることでtimes疑似命令が期待
	;		した値をつくりだす、ということだと思います、セクション(SECTION)を参考にしました
	; 3.2バイトずつ値を書き込みます、今回の場合は１６進数で55とAAで、つまり終端2バイトのブートフラグです
