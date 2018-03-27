;state 0 select texts. 
;state 1 select the text others align to. 

alignDirection = "v"
textCenter = nil
listObjects = nil
state = 0

axlCmdRegister(
	"align_text"
	'align_text
	)

procedure( align_text( )
	
	if( axlOKToProceed() then
		form = axlFormCreate( (gensym) "align_text.form" (list "outer") 'callbackForm t)
		axlFormSetField( form "radioVertical" t)
		axlFormDisplay(form)
		
		axlMsgPut( (list "Select texts to align"))
		
		axlSetFindFilter(
			?enabled '("TEXT")
			?onButtons '("TEXT")
			)
		axlOpenFindFilter()
		
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
		
		/*axlMsgPut(list("%d") length(listObjects))
		foreach( text listObjects
			axlMsgPut(list("text %s") text->text)	
		)*/
		
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
					axlDBCreateText( tempText (list nth(0 textCenter->xy) nth(1 tempXy)) tempOrientation tempLayer tempParent)
				else
					axlDBCreateText( tempText (list nth(0 tempXy) nth(1 textCenter->xy)) tempOrientation tempLayer tempParent)
				)
			)
		)
	else
		axlMsgPut("Last command not finished! ")
	)
)

(defun axlNext ()
(prog ()
	axlCancelEnterFun()
	axlClearSelSet()
	state=1
)
)

(defun axlDone ()
	state = nil
	alignDirection = nil
	textCenter = nil
	listObjects = nil
	axlFormClose(form)
	axlCancelEnterFun()
	axlClearSelSet()
	axlCloseFindFilter()
	axlShell( "done")
	axlMsgPut( "done! ")
)

(defun callbackForm (form)
	caseq( form->curField
		( "radioVertical" 		alignDirection = "v")
		( "radioHorizontal" 	alignDirection = "h")
		( "buttonNext" 			axlNext())
		( "buttonDone" 			axlDone())
	)
)