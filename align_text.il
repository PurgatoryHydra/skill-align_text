;state 0 select texts. 
;state 1 select the text others align to. 
;state 2 select align direction. 

alignDirection = "v"
textCenter = nil
listObjects = nil
listNewObjects = nil
lengthStep = 2

procedure( align_text( )


	axlUIPopupSet(nil)
	popup0 = axlUIPopupDefine( nil (list 
						(list "Next" 'axlNext0)
						(list "Oops" 'axlOops0)
						(list "Cancel" 'axlCancel0)
					))

	i = 0
	result = nil
	while( i < 10 || result == nil
		result = axlUIPopupSet(popup0)
		i++
		if( result == nil then
			axlMsgPut("result nil ")
		else
			axlMsgPut("result %s " result)
		)
	)
	
	form = axlFormCreate( (gensym) "align_text.form" (list "outer") 'callbackForm t)
	axlFormDisplay(form)
	
	axlMsgPut( (list "Select texts to align"))
	
	axlSetFindFilter(
		?enabled '("TEXT")
		?onButtons '("TEXT")
		)
	axlOpenFindFilter()
	
	;state 0
	state = 0
	
	while( state == 0
		axlSingleSelectPoint()
		if( axlGetSelSet() != nil then
			listObjects = cons(car(axlGetSelSet()), listObjects)
		else
			axlMsgPut( "We found nothing on your last pick. state: %d" state)
		)
	)
	
	while( state == 1
		axlSingleSelectPoint()
		if( axlGetSelSet() != nil then
			textCenter = car(axlGetSelSet())
			state = 2
		else
			axlMsgPut( "We found nothing on your last pick. state: %d" state)
		)
	)
	
	axlMsgPut(list("%d") length(listObjects))
	foreach( text listObjects
		axlMsgPut(list("text %s") text->text)	
	)
	
	; delete old object then create a new one. 
	foreach( text listObjects
		if( text != textCenter then
			tempXy = text->xy
			tempText = text->text
			tempOrientation = make_axlTextOrientation( ?textBlock "1", ?rotation 0.0,
?mirrored nil, ?justify "CENTER")
			tempOrientation->textBlock = text->textBlock
			tempOrientation->rotation = text->rotation
			tempOrientation->mirrored = text->isMirrored
			tempOrientation->justify = text->justify
			tempParent = text->parent
			tempLayer = text->layer
			axlDeleteObject( text)
			if( alignDirection == "v" then
					tempDBID = axlDBCreateText( tempText (list nth(0 textCenter->xy) nth(1 tempXy)) tempOrientation tempLayer tempParent)
			else
					tempDBID = axlDBCreateText( tempText (list nth(0 tempXy) nth(1 textCenter->xy)) tempOrientation tempLayer tempParent)
			)
			listNewObjects = cons( tempDBID listNewObjects)
		)
	)
)

(defun axlFillRightClickMenu (state)
(prog ()
	caseq( state
		(0 	popup0 = axlUIPopupDefine( nil
					(list 
						(list "Next" 'axlNext0)
						(list "Oops" 'axlOops0)
						(list "Cancel" 'axlCancel0)
					))
					axlUIPopupSet(popup0)
					)
		(1 	popup1 = axlUIPopupDefine( nil
					(list 
						(list "Oops" 'axlOops0)
						(list "Cancel" 'axlCancel0)
					))
		)
	)
)
)

(defun axlNext0 ()
(prog ()
	axlClearSelSet()
	axlCancelEnterFun()
	state=1
)
)

(defun axlAction ( )
(prog ()
	axlMsgPut(list("action"))
)
)

(defun axlOops0 ()
(prog ()
	axlMsgPut( (list "oops"))
)
)

(defun axlCancel0 ()
(prog ()
	axlMsgPut( (list "cancel"))
)
)

(defun axlDone ()
	state = 5
	axlCancelEnterFun()
	axlFormClose(form)
	axlClearSelSet()
	axlCloseFindFilter()
	axlUIPopupSet( nil)
	axlShell("done")
	axlMsgPut("done! ")
)

(defun callbackForm (form)
	caseq( form->curField
		( "radioVertical" 		alignDirection = "v")
		( "radioHorizontal" 	alignDirection = "h")
		( "buttonMoveUp" 		axlMoveText( cons( textCenter listNewObjects) lengthStep 0))
		( "done" 				axlDone())
	)
)

(defun axlMoveAllTextUp ()
	axlMoveText( cons( textCenter listObjects) lengthStep)
)

(defun axlMoveText ( texts distanceUpDown distanceLeftRight )
(prog ( )
	axlMsgPut("move texts")
)
)