package org.ns.genericComponents.wizard
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.containers.ViewStack;
	import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.effects.Parallel;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	import org.ns.genericComponents.wizard.events.WizardEvent;
	import org.ns.genericComponents.wizard.interfaces.IWizardStep;
	import org.ns.genericComponents.wizard.skin.WizardTitleWindowSkin;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.TextArea;
	import spark.components.TitleWindow;
	import spark.components.VGroup;
	import spark.components.supportClasses.TextBase;
	import spark.effects.Fade;
	import spark.effects.Scale;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	import spark.skins.spark.TitleWindowSkin;

	
	/**
	 *  Dispatched when the wizard is done
	 *
	 *  @eventType  com.flashmattic.component.wizard.WizardEvent.WIZARD_COMPLETE
	 *  @tiptext    wizard complete event
	 */
	[Event(name="wizardComplete", type="org.ns.genericComponent.wizard.WizardEvent")]
	
	/**
	 *  Dispatched when the wizard is canceled
	 *
	 *  @eventType  com.flashmattic.component.wizard.WizardEvent.WIZARD_CANCEL
	 *  @tiptext    wizard complete event
	 */
	[Event(name="wizardCancel", type="org.ns.genericComponent.wizard.WizardEvent")]
	
	/**
	 *  Dispatched when the wizard has moved to the next step
	 *
	 *  @eventType  com.flashmattic.component.wizard.WizardEvent.NEXT_STEP
	 *  @tiptext    wizard complete event
	 */
	[Event(name="nextStep", type="org.ns.genericComponent.wizard.WizardEvent")]
	
	/**
	 *  Dispatched when the wizard has moved to the previous step
	 *
	 *  @eventType  com.flashmattic.component.wizard.WizardEvent.PREV_STEP
	 *  @tiptext    wizard complete event
	 */
	[Event(name="prevStep", type="org.ns.genericComponent.wizard.WizardEvent")]
	
	public class Wizard extends TitleWindow
	{
		
		[SkinPart(required="true")] public var lblStepDescription:Label;
		[SkinPart(required="true")] public var grpFilAriane:HGroup;
		[SkinPart(required="true")] public var grpMain:Group;
		[SkinPart(required="true")] public var stepsViewStack:ViewStack;
		[SkinPart(required="true")] public var imgStepLogo:Image;
		
		private const WIZARD_MIN_WIDTH:Number = 300;
		private const WIZARD_MIN_HEIGHT:Number = 200;
		
		private var _pgBar:ProgressBar;
		private var _showProgressBar:Boolean;
		private var _previousButton:Button;
		private var _nextButton:Button;
		private var _cancelButton:Button;
		private var _dataModel:*;
		private var _steps:Array;
		private var _stepDescriptionsArray:Array;
		private var _stepDescriptionText:Label;
		private var _currentStepIndex:int;
		private var _stepsMaxWidth:Number = WIZARD_MIN_WIDTH;
		private var _stepsMaxHeight:Number = WIZARD_MIN_HEIGHT;
		private var _stepValidationWatcher:ChangeWatcher;
		private var _currentStep:IWizardStep;
		private var _showSummaryStep:Boolean;
		private var _logo:Class;
		private var _summaryStep:IWizardStep;
		private var _summaryText:Text;
		private var _summarArray:Array;
		private var _summaryString:String;
		// Commit properties flags
		private var _wizardStepsChanged:Boolean = false;

		//skin class
		private var WizardSkinClass:Class=WizardTitleWindowSkin;
		
		public function Wizard()
		{
			super();
			
			this.setStyle("skinClass",WizardSkinClass)
			
			this.addEventListener(CloseEvent.CLOSE, onClose);
			
			//add effect
			var fade:Fade=new Fade;
			var scale:Scale=new Scale;
			
			var win_addedEffect:Parallel=new Parallel;
			win_addedEffect.children=[fade,scale];
			
			var win_removedEffect:Parallel=new Parallel;
			win_removedEffect.children=[scale,fade];
			
			this.setStyle("showEffect",win_addedEffect);
			this.setStyle("hideEffect",win_removedEffect);
			
			// Reset the current step to be the first
			_currentStepIndex = 0;
			// Set the minimum scale of this wizard
			this.minWidth = WIZARD_MIN_WIDTH;
			this.minHeight = WIZARD_MIN_HEIGHT;
			// Reset the _summarArray 
			_summarArray = new Array();
			// Create the summary step although we're not sure we are actually 
			// going to use it
			createSummaryStep();

		}
		
		// OVERRIDES ------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if (_logo!=null){
				imgStepLogo.source=_logo;
			}
			
			// Create the control bar for the wizard
			initWizardControlBar();

			//init viewstack
			stepsViewStack.creationPolicy = "all";
			stepsViewStack.addEventListener(FlexEvent.CREATION_COMPLETE, onStepsViewStackCreationComplete, false, 0, true);
			
		}
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			if (_wizardStepsChanged) {
				initWizardSteps();
				_wizardStepsChanged = false;
			}
		}
				
		/**
		 * The Wizard sets it's own scale according to its steps width and 
		 * height. This is why we don't want the end developer to set the 
		 * scale, since it will only tampre with the auto scaling.
		 * @param value
		 */             
		override public function set width(value:Number):void 
		{
			throw new Error("Width property cannot be set for the Wizard");
		}
		
		/**
		 * The Wizard sets it's own scale according to its steps width and 
		 * height. This is why we don't want the end developer to set the 
		 * scale, since it will only tampre with the auto scaling.
		 * @param value
		 */                             
		override public function set height(value:Number):void 
		{
			throw new Error("Height property cannot be set for the Wizard");
		}
	
		
		// PRIVATES ------------------------------------------------------------
		/**
		 * Lays down the buttons for "next", "previous" and "cancel". Also 
		 * attach event listeners for them. 
		 */             
		private function initWizardControlBar():void 
		{
			this.controlBarContent=new Array();
			
			
			if (_pgBar == null && _showProgressBar==true) {
				_pgBar=new ProgressBar();
				_pgBar.minimum=0;
				_pgBar.mode="manual";
				_pgBar.visible=false;
				_pgBar.label="%3%% loaded";
				_pgBar.labelPlacement="right";	
				this.controlBarContent.push(_pgBar);
			}
				
			// if the button doesn't exist, create button
			if (_cancelButton == null) {
				_cancelButton = new Button();
				_cancelButton.label = "cancel";
				_cancelButton.addEventListener(MouseEvent.CLICK, onCancel, false, 0, true);
				this.controlBarContent.push(_cancelButton);
			}
			
			if (_previousButton == null) {
				_previousButton = new Button();
				_previousButton.addEventListener(MouseEvent.CLICK, onPrevious, false, 0, true);
				_previousButton.label = "previous";
				this.controlBarContent.push(_previousButton);
			}
			
			// if the button doesn't exist, create button
			if (_nextButton == null) {
				_nextButton = new Button();
				_nextButton.label ="next";
				_nextButton.addEventListener(MouseEvent.CLICK, onNext, false, 0, true);
				this.controlBarContent.push(_nextButton);
			}
		}
		
		/**
		 * Adds all the steps to the steps view stack, set the array
		 * of description and create the "fil d'arianne" with step name
		 */             
		private function initWizardSteps():void 
		{
			_stepDescriptionsArray = new Array();
			var lbl:FilArianeLabel
			var i:int=1;
			for each (var step:IWizardStep in steps) {
				stepsViewStack.addChild(step as DisplayObject);
				_stepDescriptionsArray.push(step.stepDescription);
				
				if (step.stepName!=null){
					lbl=new FilArianeLabel()
					lbl.id="step" + String(i);
					lbl.text=String(i) + ". " + step.stepName;

					grpFilAriane.addElement(lbl);
					i++;
				}			
			}		
			
			//if _showSummaryStep==true ==> add element in the "fil d'ariane"
			if (_showSummaryStep==true){
				lbl=new FilArianeLabel();
				lbl.id="step" + String(i);
				lbl.text=String(i) + ". Finish";
				grpFilAriane.addElement(lbl);
			}
			
			validateWizardCurrentStep();
		}
		
		private function validateWizardCurrentStep():void 
		{
			// Set the selected child of the steps view stack to the current
			// step of the wizard
			stepsViewStack.selectedIndex = currentStepIndex;
			// Set the description of the current step
			lblStepDescription.text = _stepDescriptionsArray[currentStepIndex];
			// Bind the validation of the step with the next step availability
			_currentStep = stepsViewStack.selectedChild as IWizardStep;
			// Validate the next and previous step
			validateNextStep();
			validatePrevStep();
			// Setup the watcher for the next button
			if (_stepValidationWatcher) {
				_stepValidationWatcher.unwatch();
			} 
			_stepValidationWatcher = BindingUtils.bindProperty(_nextButton, "enabled", _currentStep, "isValid");
			//change style of current step in "fil d'arianne"
			SelectStep(currentStepIndex);
		}
		
		/**
		 * Change style (bold) for the selected step in 
		 * "Fil d'arianne"
		 */             
		private function SelectStep(stepIndex:Number):void 
		{
			var count:uint = grpFilAriane.numElements;		
			for (var i:int = 0; i < count; i++){		
				if (grpFilAriane.getElementAt(i) is FilArianeLabel){
					var lbl:FilArianeLabel=grpFilAriane.getElementAt(i) as FilArianeLabel;
					//if (lbl.id=="step"+ String(stepIndex+1)){
					if (i==stepIndex){
						lbl.selected=true;
					}else{
						lbl.selected=false;
					}
				}
			}
		}
		
		
		/**
		 * Wraps up the wizard by dispatching a WizardEvent.WIZARD_COMPLETE and
		 * disabling all the buttons 
		 * event
		 */             
		private function wrapUpWizard():void 
		{
			_previousButton.enabled = false;
			_nextButton.enabled = false;
			_cancelButton.enabled = false;
			
			if (_showProgressBar==true){
				_pgBar.visible=true;
			}
			
			// Dispatch the WizardEvent.WIZARD_COMPLETE event
			var e:WizardEvent = new WizardEvent(WizardEvent.WIZARD_COMPLETE,_currentStepIndex);
			dispatchEvent(e);
		}
		
		/**
		 * When the view stack containing all the steps has finished creating
		 * itself, and it created them all since we've ordered it to do wo, we
		 * now wish the get the max width and height of the the steps and set it
		 * to the view stack. we do that so that the end developer using this 
		 * component won't need to care about sizing his Wizard, and all the 
		 * scaling will be done behind the scenes.
		 * @param event
		 */             
		private function scaleStepsViewStack():void 
		{
			for (var i:int = 0; i < stepsViewStack.numChildren; i++) {
				var step:UIComponent = stepsViewStack.getChildAt(i) as UIComponent;
				if (step.explicitWidth > _stepsMaxWidth) {
					_stepsMaxWidth = step.explicitWidth;
				}
				if (step.measuredWidth > _stepsMaxWidth) {
					_stepsMaxWidth = step.measuredWidth;
				}
				if (step.explicitHeight> _stepsMaxHeight) {
					_stepsMaxHeight = step.explicitHeight;
				}
				if (step.measuredHeight > _stepsMaxHeight) {
					_stepsMaxHeight = step.measuredHeight;
				}
			}
			stepsViewStack.width = _stepsMaxWidth
			stepsViewStack.height = _stepsMaxHeight;
			
			stepsViewStack.invalidateSize();
			
			//get the width of the longer label in the "fil d'ariane"
			/*var maxFilArianeWidth:Number=0;
			var count:uint = grpFilAriane.numElements;			
			for (var j:int = 0; j < count; j++){		
				if (grpFilAriane.getElementAt(j) is Label){
					var lbl:Label=grpFilAriane.getElementAt(j) as Label;
					if (maxFilArianeWidth<lbl.width){
						maxFilArianeWidth=lbl.width;
					}
				}
			}			
			
			grpFilAriane.width=maxFilArianeWidth + 15;
			grpFilAriane.invalidateSize();*/
			
		}
		
		/**
		 * Get the step desicion from the current step and store it in the data 
		 * model 
		 */             
		private function retreiveCurrentStepDecision():void 
		{
			if (_currentStep.dataField) {
				dataModel[_currentStep.dataField] = _currentStep.stepDecision;
				_summarArray[_currentStep.stepName] = _currentStep.readableStepDecision;        
			}
		}
		
		/**
		 * Gather the information from the _summaryDict and set it in a nice
		 * string format to be displayed later on the summary step 
		 */             
		private function setSummaryContent():void 
		{
			_summaryString = "";
			for (var stepName:String in _summarArray) {
				if (stepName != "null") {
					_summaryString += "<B>" + stepName + ":</B><BR>" +  _summarArray[stepName] + "<BR><BR>";        
				}
			}
			// Set the summary string to the summary step text
			_summaryText.htmlText = _summaryString;
		}
		
		/**
		 * When there are still steps ahead we keep the "Next" label to the 
		 * next button, but when we reach the final step, it's time to put the
		 * "Finish" label on it
		 */             
		private function validateNextStep():void 
		{
			var nextStepIndex:int = currentStepIndex + 1;
			if (nextStepIndex >= steps.length) {
				_nextButton.label = "finish"; 
				// Set the summary string to the summary step text
				setSummaryContent();
			} else {
				_nextButton.label = "next";
			}
		}
		
		/**
		 * Sets the previous button state according to the current step index.
		 * In plain words, if we don't have anywhere to go backwards, simply
		 * remove the previous button.
		 */             
		private function validatePrevStep():void 
		{
			if (_previousButton) {
				_previousButton.visible = _previousButton.enabled = currentStepIndex > 0;
			}
		}
		
		/**
		 * Creates the summary step and in it creates the TextArea that will 
		 * hold the summary information for the wizard. At this point we don't
		 * even know if we're going to use the summary step but we create it 
		 * anyway since the "code-smell" of many IF's is more disturbing than 
		 * the performance price we pay. 
		 */             
		private function createSummaryStep():void
		{
			_summaryStep = new WizardStep()
			_summaryStep.isValid = true;
			_summaryStep.stepDescription = "Description";
			_summaryStep.percentHeight = 100;
			_summaryStep.percentWidth = 100;
			_summaryText =new Text();
			_summaryText.mouseChildren=false;
			_summaryText.percentHeight = 100;
			_summaryText.percentWidth = 100;			
			_summaryStep.addChild(_summaryText);
		}
		
		// EVENT HANDLERS ------------------------------------------------------
		private function onStepsViewStackCreationComplete(event:FlexEvent):void 
		{
			scaleStepsViewStack();
		}
		
		/**
		 * Called when the user has pressed the close button on the wizard
		 * @param event
		 */             
		private function onClose(event:CloseEvent):void 
		{
			cancelWizard();
		}
		
		/**
		 * Called when the user uses the cancel button on the wizard 
		 * @param event
		 */             
		private function onCancel(event:MouseEvent):void 
		{
			cancelWizard();
		}
		
		private function onPrevious(event:MouseEvent):void 
		{
			currentStepIndex--;
			validateWizardCurrentStep();
			// Dispatch the WizardEvent.PREV_STEP event
			var e:WizardEvent = new WizardEvent(WizardEvent.PREV_STEP,_currentStepIndex);
			dispatchEvent(e);       
		}
		
		private function onNext(event:MouseEvent):void 
		{
			// Get the step desicion from the current step
			retreiveCurrentStepDecision();
			// Go to the next step
			// If there are no more steps in the wizard, wrap it up
			if (++currentStepIndex == _steps.length) {
				wrapUpWizard();
			} else {
				validateWizardCurrentStep();
				// Dispatch the WizardEvent.NEXT_STEP event
				var e:WizardEvent = new WizardEvent(WizardEvent.NEXT_STEP,_currentStepIndex);
				dispatchEvent(e);       
			}
		}
		
		/**
		 * A routine of action to be executed when the user decided to cancel
		 * the wizard
		 * - Dispatching an event to indicate the cancelation
		 */             
		private function cancelWizard():void 
		{
			var e:WizardEvent = new WizardEvent(WizardEvent.WIZARD_CANCEL,_currentStepIndex);
			dispatchEvent(e);                       
		}
		
		// GETTER/SETTER -------------------------------------------------------
		public function get dataModel():* 
		{
			return _dataModel;
		}
		
		public function set dataModel(value:*):void 
		{
			_dataModel = value;
		}
		
		public function get steps():Array 
		{
			return _steps;
		}
		;
		public function set steps(value:Array):void 
		{
			_steps = value;
			if (_showSummaryStep) {
				_steps.push(_summaryStep);
			}
			_wizardStepsChanged = true;
			invalidateProperties();
		}
		
		private function set currentStepIndex(value:int):void 
		{
			_currentStepIndex = value;
		} 
		
		private function get currentStepIndex():int 
		{
			return _currentStepIndex;
		}
		
		public function set logo(value:Class):void 
		{
			_logo = value;
		}
		
		public function set showSummaryStep(value:Boolean):void 
		{
			_showSummaryStep = value;
		}
		
		public function set showProgressBar(value:Boolean):void 
		{
			_showProgressBar = value;
		}

		public function get showProgressBar():Boolean 
		{
			return _showProgressBar
		}
		
		public function setProgressBar(value:Array):void 
		{
			if (_pgBar!=null && _showProgressBar==true){
				_pgBar.setProgress(value[0],value[1])
			}
		}
	}
}