<?php
/*************************************************************************************
 * perl.php
 * --------
 * Author: Andrew Roth
 *
 * MEL language file for GeSHi.
 *
 *************************************************************************************
 *
 *     This file is part of GeSHi.
 *
 *   GeSHi is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   GeSHi is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with GeSHi; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 ************************************************************************************/

$language_data = array (
    'LANG_NAME' => 'Maya Mel',
    'COMMENT_SINGLE' => array(1 => '//'),
    'COMMENT_MULTI' => array(
        '/*' => '*/',
        ),
    'CASE_KEYWORDS' => GESHI_CAPS_NO_CHANGE,
    'QUOTEMARKS' => array('"','`'),
    'HARDQUOTE' => array("'", "'"),            // An optional 2-element array defining the beginning and end of a hard-quoted string
    'HARDESCAPE' => array('\\\'',),
        // Things that must still be escaped inside a hard-quoted string
        // If HARDQUOTE is defined, HARDESCAPE must be defined
        // This will not work unless the first character of each element is either in the
        // QUOTEMARKS array or is the ESCAPE_CHAR
    'ESCAPE_CHAR' => '\\',
    'KEYWORDS' => array(
        1 => array(
            'and', 'as', 'case', 'catch', 'continue', 'do', 'else', 'exit', 
            'false', 'for', 'from', 'if', 'in', 'local', 'not', 'of', 'off', 
            'on', 'or', 'random', 'return', 'then', 'throw', 'to', 'true', 
            'try', 'when', 'where', 'while', 'with', 'vector'
            ),
        2 => array(
            'workspace', 'wrinklwrinkleContext', 'writeTake', 'xbmLangPathList', 'xform', 'xpmPicker',
            'about', 'abs', 'addAttr', 'addAttributeEditorNodeHelp', 'addDynamic', 'addExtension',
            'addPanelCategory', 'addPP', 'addPrefixToName', 'advanceToNextDrivenKey', 'affectedNet', 'affects',
            'air', 'alias', 'aliasAttr', 'align', 'alignCtx', 'alignCurve',
            'allNodeTypes', 'allViewFit', 'ambientLight', 'angle', 'angleBetween', 'animCurveEditor',
            'animLayer', 'animView', 'annotate', 'appendStringArray', 'applicationName', 'applyAttrPattern',
            'applyTake', 'arclen', 'arcLenDimContext', 'arcLengthDimension', 'arrayMapper', 'art3dPaintCtx',
            'artAttrPaintVertexCtx', 'artAttrSkinPaintCtx', 'artAttrTool', 'artBuildPaintMenu', 'artFluidAttrCtx', 'artPuttyCtx',
            'artSetPaintCtx', 'artUserPaintCtx', 'assignCommand', 'assignInputDevice', 'assignNSolver', 'assignViewportFactories',
            'attachDeviceAttr', 'attachSurface', 'attrColorSliderGrp', 'attrCompatibility', 'attrControlGrp', 'attrEnumOptionMenu',
            'attrFieldGrp', 'attrFieldSliderGrp', 'attributeExists', 'attributeInfo', 'attributeMenu', 'attributeName',
            'attrNavigationControlGrp', 'attrPresetEditWin', 'audioTrack', 'autoKeyframe', 'autoPlace', 'autoSave',
            'bakeFluidShading', 'bakePartialHistory', 'bakeResults', 'bakeSimulation', 'basename', 'basenameEx',
            'baseView', 'batchRender', 'bessel', 'bevel', 'bevelPlus', 'bezierAnchorPreset',
            'bezierCurveToNurbs', 'bezierInfo', 'bindSkin', 'binMembership', 'blend2', 'blendShape',
            'blendShapePanel', 'blendTwoAttr', 'blindDataType', 'boneLattice', 'boundary', 'boxDollyCtx',
            'bufferCurve', 'buildBookmarkMenu', 'buildKeyframeMenu', 'button', 'buttonManip', 'cacheFile',
            'cacheFileMerge', 'cacheFileTrack', 'callbacks', 'callPython', 'camera', 'cameraSet',
            'canCreateManip', 'canvas', 'capitalizeString', 'catch', 'catchQuiet', 'CBG',
            'changeSubdivComponentDisplayLevel', 'changeSubdivRegion', 'channelBox', 'character', 'characterize', 'characterMap',
            'checkBox', 'checkBoxGrp', 'checkDefaultRenderGlobals', 'choice', 'circle', 'circularFillet',
            'clear', 'clearCache', 'clearParticleStartState', 'clip', 'clipEditor', 'clipEditorCurrentTimeCtx',
            'clipSchedule', 'clipSchedulerOutliner', 'clipTrimBefore', 'closeCurve', 'closeSurface', 'cluster',
            'cmdScrollFieldExecuter', 'cmdScrollFieldReporter', 'cmdShell', 'coarsenSubdivSelectionList', 'collision', 'color',
            'colorEditor', 'colorIndex', 'colorIndexSliderGrp', 'colorSliderButtonGrp', 'colorSliderGrp', 'columnLayout',
            'commandLine', 'commandPort', 'compactHairSystem', 'componentBox', 'componentEditor', 'computePolysetVolume',
            'cone', 'confirmDialog', 'connectAttr', 'connectControl', 'connectDynamic', 'connectionInfo',
            'constrain', 'constrainValue', 'constructionHistory', 'container', 'containerAssignMaterial', 'containerAssignTemplate',
            'containerAutopublishRoot', 'containerBind', 'containerCreateBindingSet', 'containerDefaultBindingSet', 'containerProxy', 'containerPublish',
            'containerRmbMenu', 'containerTemplate', 'containerView', 'containsMultibyte', 'contextInfo', 'control',
            'convertLightmap', 'convertSolidTx', 'convertTessellation', 'convertUnit', 'copyArray', 'copyAttr',
            'copyFlexor', 'copyKey', 'copySkinWeights', 'cos', 'createAttrPatterns', 'createCurveField',
            'createEditor', 'createHairCurveNode', 'createLayeredPsdFile', 'createMotionField', 'createNConstraint', 'createNewShelf',
            'createRenderLayer', 'createSubdivRegion', 'cross', 'crossProduct', 'ctxAbort', 'ctxCompletion',
            'ctxTraverse', 'currentCtx', 'currentTime', 'currentTimeCtx', 'currentUnit', 'curve',
            'curveCVCtx', 'curveEditorCtx', 'curveEPCtx', 'curveIntersect', 'curveMoveEPCtx', 'curveOnSurface',
            'curveSketchCtx', 'cutKey', 'cycleCheck', 'cylinder', 'dagObjectCompare', 'dagPose',
            'dbcount', 'dbmessage', 'defaultLightListCheckBox', 'defaultNavigation', 'defineDataServer', 'defineVirtualDevice',
            'deformerWeights', 'deg_to_rad', 'delete', 'deleteAllContainers', 'deleteAttr', 'deleteAttrPattern',
            'deleteShadingGroupsAndMaterials', 'deleteShelfTab', 'deleteUI', 'deleteUnusedBrushes', 'delrandstr', 'destroyLayout',
            'detachDeviceAttr', 'detachSurface', 'deviceEditor', 'deviceManager', 'devicePanel', 'dgdirty',
            'dgInfo', 'dgmodified', 'dgtimer', 'dimWhen', 'directionalLight', 'directKeyCtx',
            'dirname', 'disable', 'disconnectAttr', 'disconnectJoint', 'displacementToPoly', 'displayAffected',
            'displayCull', 'displayLevelOfDetail', 'displayNClothMesh', 'displayPref', 'displayRGBColor', 'displaySmoothness',
            'displayString', 'displayStyle', 'displaySurface', 'distanceDimContext', 'distanceDimension', 'doBlur',
            'dolly', 'dollyCtx', 'dopeSheetEditor', 'doPublishNode', 'dot', 'dotProduct',
            'drag', 'dragAttrContext', 'draggerContext', 'dropoffLocator', 'duplicate', 'duplicateCurve',
            'dynamicConstraintMembership', 'dynamicLoad', 'dynCache', 'dynConnectToTime', 'dynControl', 'dynExport',
            'dynGlobals', 'dynPaintEditor', 'dynParticleCtx', 'dynPref', 'editAttrLimits', 'editDisplayLayerGlobals',
            'editor', 'editorTemplate', 'editRenderLayerAdjustment', 'editRenderLayerGlobals', 'editRenderLayerMembers', 'effector',
            'emitter', 'enableDevice', 'encodeString', 'endString', 'endsWith', 'env',
            'equivalentTol', 'erf', 'error', 'eval', 'evalDeferred', 'evalEcho',
            'exactWorldBoundingBox', 'exclusiveLightCheckBox', 'exec', 'executeForEachObject', 'exists', 'exp',
            'expression', 'expressionEditorListen', 'extendCurve', 'extendSurface', 'extrude', 'fcheck',
            'feof', 'fflush', 'fgetline', 'fgetword', 'file', 'fileBrowserDialog',
            'fileDialog2', 'fileExtension', 'fileInfo', 'filetest', 'filletCurve', 'filter',
            'filterExpand', 'filterStudioImport', 'findAllIntersections', 'findAnimCurves', 'findKeyframe', 'findMenuItem',
            'findRelatedSkinCluster', 'findType', 'firstParentOf', 'fitBspline', 'flexor', 'floatArrayContains',
            'floatArrayFind', 'floatArrayInsertAtIndex', 'floatArrayRemove', 'floatArrayRemoveAtIndex', 'floatArrayToString', 'floatEq',
            'floatFieldGrp', 'floatScrollBar', 'floatSlider', 'floatSlider2', 'floatSliderButtonGrp', 'floatSliderGrp',
            'flow', 'flowLayout', 'fluidCacheInfo', 'fluidEmitter', 'fluidVoxelInfo', 'flushUndo',
            'fontDialog', 'fopen', 'format', 'formLayout', 'formValidObjectName', 'fprint',
            'frameLayout', 'fread', 'freeFormFillet', 'frewind', 'fromNativePath', 'fwrite',
            'gauss', 'geometryConstraint', 'getAllChains', 'getApplicationVersionAsFloat', 'getAttr', 'getChain',
            'getCurrentContainer', 'getDefaultBrush', 'getenv', 'getFileList', 'getFluidAttr', 'getInputDeviceRange',
            'getMayaPanelTypes', 'getModifiers', 'getModulePath', 'getNextFreeMultiIndex', 'getNextFreeMultiIndexForSource', 'getPanel',
            'getpid', 'getPluginResource', 'getProcArguments', 'getRenderDependencies', 'getRenderTasks', 'getSelectedNObjs',
            'glRender', 'glRenderEditor', 'gmatch', 'goal', 'gotoBindPose', 'grabColor',
            'gradientControlNoAttr', 'graphDollyCtx', 'graphSelectContext', 'graphTrackCtx', 'gravity', 'grid',
            'group', 'groupObjectsByName', 'hardenPointCurve', 'hardware', 'hardwareRenderPanel', 'headsUpDisplay',
            'help', 'helpLine', 'hermite', 'HfAddAttractorToAS', 'HfAssignAS', 'HfBuildEqualMap',
            'HfBuildFurImages', 'HfCancelAFR', 'HfConnectASToHF', 'HfCreateAttractor', 'HfDeleteAS', 'HfEditAS',
            'HfRemoveAttractorFromAS', 'HfSelectAttached', 'HfSelectAttractors', 'HfUnassignAS', 'hide', 'hikGlobals',
            'hitTest', 'hotBox', 'hotkey', 'hotkeyCheck', 'hsv_to_rgb', 'hudButton',
            'hudSliderButton', 'hwReflectionMap', 'hwRender', 'hwRenderLoad', 'hyperGraph', 'hyperPanel',
            'hypot', 'iconTextButton', 'iconTextCheckBox', 'iconTextRadioButton', 'iconTextRadioCollection', 'iconTextScrollList',
            'ikfkDisplayMethod', 'ikHandle', 'ikHandleCtx', 'ikHandleDisplayScale', 'ikSolver', 'ikSplineHandleCtx',
            'ikSystemInfo', 'illustratorCurves', 'image', 'imagePlane', 'imfPlugins', 'inheritTransform',
            'insertJointCtx', 'insertKeyCtx', 'insertKnotCurve', 'insertKnotSurface', 'instance', 'instanceable',
            'intArrayContains', 'intArrayCount', 'intArrayFind', 'intArrayInsertAtIndex', 'intArrayRemove', 'intArrayRemoveAtIndex',
            'internalVar', 'intersect', 'interToUI', 'intField', 'intFieldGrp', 'intScrollBar',
            'intSliderGrp', 'iprEngine', 'isAnimCurve', 'isConnected', 'isDirty', 'isolateSelect',
            'isSameObject', 'isTrue', 'isValidObjectName', 'isValidString', 'isValidUiName', 'itemFilter',
            'itemFilterRender', 'itemFilterType', 'joint', 'jointCluster', 'jointCtx', 'jointDisplayScale',
            'keyframe', 'keyframeOutliner', 'keyframeRegionCurrentTimeCtx', 'keyframeRegionDirectKeyCtx', 'keyframeRegionDollyCtx', 'keyframeRegionInsertKeyCtx',
            'keyframeRegionScaleKeyCtx', 'keyframeRegionSelectKeyCtx', 'keyframeRegionSetKeyCtx', 'keyframeRegionTrackCtx', 'keyframeStats', 'keyingGroup',
            'lassoContext', 'lattice', 'latticeDeformKeyCtx', 'launch', 'launchImageEditor', 'layerButton',
            'layeredTexturePort', 'layout', 'layoutDialog', 'license', 'lightlink', 'lightList',
            'lineIntersection', 'linstep', 'listAnimatable', 'listAttr', 'listAttrPatterns', 'listCameras',
            'listDeviceAttachments', 'listHistory', 'listInputDeviceAxes', 'listInputDeviceButtons', 'listInputDevices', 'listMenuAnnotation',
            'listPanelCategories', 'listRelatives', 'listSets', 'listTransforms', 'listUnselected', 'loadFluid',
            'loadPlugin', 'loadPluginLanguageResources', 'loadPrefObjects', 'loadUI', 'localizedPanelLabel', 'localizedUIComponentLabel',
            'lockNode', 'loft', 'log', 'longNameOf', 'lookThru', 'ls',
            'lsType', 'lsUI', 'mag', 'makebot', 'makeCurvesDynamic', 'makeCurvesDynamicHairs',
            'makeLive', 'makePaintable', 'makePassiveCollider', 'makeRoll', 'makeSingleSurface', 'makeTubeOn',
            'manipMoveLimitsCtx', 'manipOptions', 'manipRotateContext', 'manipRotateLimitsCtx', 'manipScaleContext', 'manipScaleLimitsCtx',
            'match', 'max', 'maxfloat', 'maxint', 'Mayatomr', 'melInfo',
            'menu', 'menuBarLayout', 'menuEditor', 'menuItem', 'menuItemToShelf', 'menuSet',
            'messageLine', 'min', 'minfloat', 'minimizeApp', 'minint', 'mirrorJoint',
            'modelEditor', 'modelPanel', 'mouse', 'move', 'moveCacheToInput', 'moveIKtoFK',
            'moveVertexAlongDirection', 'movieInfo', 'movIn', 'movOut', 'multiProfileBirailSurface', 'mute',
            'nameField', 'namespace', 'namespaceInfo', 'nBase', 'nClothConvertOutput', 'nClothVertexEditor',
            'nextOrPreviousFrame', 'nodeCast', 'nodeEditor', 'nodeIconButton', 'nodeOutliner', 'nodePreset',
            'nodeType', 'noise', 'nonLinear', 'normalConstraint', 'normalize', 'nParticle',
            'nurbsCopyUVSet', 'nurbsCube', 'nurbsCurveToBezier', 'nurbsEditUV', 'nurbsPlane', 'nurbsSelect',
            'nurbsToPoly', 'nurbsToPolygonsPref', 'nurbsToSubdiv', 'nurbsToSubdivPref', 'nurbsUVSet', 'nurbsViewDirectionVector',
            'objectLayer', 'objectType', 'objectTypeUI', 'objExists', 'obsoleteProc', 'oceanNurbsPreviewPlane',
            'offsetCurveOnSurface', 'offsetSurface', 'ogs', 'ogsRender', 'openGLExtension', 'openMayaPref',
            'optionMenuGrp', 'optionVar', 'orbit', 'orbitCtx', 'orientConstraint', 'outlinerEditor',
            'overrideModifier', 'paintEffectsDisplay', 'pairBlend', 'palettePort', 'panel', 'paneLayout',
            'panelHistory', 'panZoom', 'panZoomCtx', 'paramDimContext', 'paramDimension', 'paramLocator',
            'parentConstraint', 'particle', 'particleExists', 'particleFill', 'particleInstancer', 'particleRenderInfo',
            'pasteKey', 'pathAnimation', 'pause', 'pclose', 'percent', 'performanceOptions',
            'pickWalk', 'picture', 'pixelMove', 'planarSrf', 'plane', 'play',
            'playblast', 'plugAttr', 'pluginInfo', 'pluginResourceUtil', 'plugMultiAttrs', 'plugNode',
            'pointConstraint', 'pointCurveConstraint', 'pointLight', 'pointMatrixMult', 'pointOnCurve', 'pointOnPolyConstraint',
            'pointPosition', 'poleVectorConstraint', 'polyAppend', 'polyAppendFacetCtx', 'polyAppendVertex', 'polyAutoProjection',
            'polyAverageVertex', 'polyBevel', 'polyBlendColor', 'polyBlindData', 'polyBoolOp', 'polyBridgeEdge',
            'polyCheck', 'polyChipOff', 'polyClipboard', 'polyCloseBorder', 'polyCollapseEdge', 'polyCollapseFacet',
            'polyColorDel', 'polyColorMod', 'polyColorPerVertex', 'polyColorSet', 'polyCompare', 'polyCone',
            'polyCopyUV', 'polyCrease', 'polyCreaseCtx', 'polyCreateFacet', 'polyCreateFacetCtx', 'polyCube',
            'polyCutCtx', 'polyCylinder', 'polyCylindricalProjection', 'polyDelEdge', 'polyDelFacet', 'polyDelVertex',
            'polyDuplicateEdge', 'polyEditUV', 'polyEditUVShell', 'polyEvaluate', 'polyExtrudeEdge', 'polyExtrudeFacet',
            'polyFlipEdge', 'polyFlipUV', 'polyForceUV', 'polyGeoSampler', 'polyHelix', 'polyHole',
            'polyInstallAction', 'polyLayoutUV', 'polyListComponentConversion', 'polyMapCut', 'polyMapDel', 'polyMapSew',
            'polyMergeEdge', 'polyMergeEdgeCtx', 'polyMergeFacet', 'polyMergeFacetCtx', 'polyMergeUV', 'polyMergeVertex',
            'polyMoveEdge', 'polyMoveFacet', 'polyMoveFacetUV', 'polyMoveUV', 'polyMoveVertex', 'polyMultiLayoutUV',
            'polyNormalizeUV', 'polyNormalPerVertex', 'polyOptions', 'polyOptUvs', 'polyOutput', 'polyPipe',
            'polyPlane', 'polyPlatonicSolid', 'polyPoke', 'polyPrimitive', 'polyPrism', 'polyProjectCurve',
            'polyPyramid', 'polyQuad', 'polyQueryBlindData', 'polyReduce', 'polySelect', 'polySelectConstraint',
            'polySelectCtx', 'polySelectEditCtx', 'polySeparate', 'polySetToFaceNormal', 'polySewEdge', 'polyShortestPathCtx',
            'polySmooth', 'polySoftEdge', 'polySphere', 'polySphericalProjection', 'polySplit', 'polySplitCtx',
            'polySplitEdge', 'polySplitRing', 'polySplitVertex', 'polyStraightenUVBorder', 'polySubdivideEdge', 'polySubdivideFacet',
            'polyToSubdiv', 'polyTransfer', 'polyTriangulate', 'polyUnite', 'polyUVRectangle', 'polyUVSet',
            'popen', 'popupMenu', 'pose', 'pow', 'preloadRefEd', 'print',
            'progressWindow', 'projectCurve', 'projectionContext', 'projectionManip', 'projectTangent', 'promptDialog',
            'propMove', 'psdChannelOutliner', 'psdEditTextureFile', 'psdExport', 'psdTextureFile', 'publishAnchorNodes',
            'putenv', 'pwd', 'python', 'querySubdiv', 'quit', 'rad_to_deg',
            'radioButton', 'radioButtonGrp', 'radioCollection', 'radioMenuItemCollection', 'rampColorPort', 'rand',
            'randstate', 'rangeControl', 'readTake', 'rebuildCurve', 'rebuildSurface', 'recordAttr',
            'redo', 'reference', 'referenceEdit', 'referenceQuery', 'refineSubdivSelectionList', 'refresh',
            'refreshEditorTemplates', 'regionSelectKeyCtx', 'registerPluginResource', 'rehash', 'relationship', 'reloadImage',
            'removeMultiInstance', 'removePanelCategory', 'rename', 'renameAttr', 'renameSelectionList', 'renameUI',
            'renderer', 'renderGlobalsNode', 'renderInfo', 'renderLayerParent', 'renderLayerPostProcess', 'renderLayerUnparent',
            'renderPartition', 'renderPassRegistry', 'renderQualityNode', 'renderSettings', 'renderThumbnailUpdate', 'renderWindowEditor',
            'reorder', 'reorderContainer', 'reorderDeformers', 'reparentStrokes', 'requires', 'reroot',
            'resetAE', 'resetPfxToPolyCamera', 'resetTool', 'resolutionNode', 'resourceManager', 'retarget',
            'reverseCurve', 'reverseSurface', 'revolve', 'rgb_to_hsv', 'rigidBody', 'rigidSolver',
            'rollCtx', 'rootOf', 'rot', 'rotate', 'rotationInterpolation', 'roundConstantRadius',
            'rowLayout', 'runTimeCommand', 'runup', 'sampleImage', 'saveAllShelves', 'saveAttrPreset',
            'saveImage', 'saveInitialState', 'saveMenu', 'savePrefObjects', 'savePrefs', 'saveShelf',
            'saveViewportSettings', 'scale', 'scaleBrushBrightness', 'scaleComponents', 'scaleConstraint', 'scaleKey',
            'sceneEditor', 'sceneTimeWarp', 'sceneUIReplacement', 'scmh', 'scriptCtx', 'scriptEditorInfo',
            'scriptedPanelType', 'scriptJob', 'scriptNode', 'scriptTable', 'scriptToShelf', 'scrollField',
            'sculpt', 'searchPathArray', 'seed', 'select', 'selectContext', 'selectCurveCV',
            'selectionConnection', 'selectKey', 'selectKeyCtx', 'selectKeyframeRegionCtx', 'selectMode', 'selectPref',
            'selectType', 'selLoadSettings', 'separator', 'sequenceManager', 'setAttr', 'setAttrEnumResource',
            'setAttrNiceNameResource', 'setConstraintRestPosition', 'setCustomAttrEnumResource', 'setCustomAttrNiceNameResource', 'setDefaultShadingGroup', 'setDrivenKeyframe',
            'setEditCtx', 'setFluidAttr', 'setFocus', 'setInfinity', 'setInputDeviceMapping', 'setKeyCtx',
            'setKeyframeBlendshapeTargetWts', 'setKeyPath', 'setMenuMode', 'setNClothRestShape', 'setNClothStartFromMesh', 'setNodeNiceNameResource',
            'setParent', 'setParticleAttr', 'setPfxToPolyCamera', 'setPluginResource', 'setProject', 'setRenderPassType',
            'setStampDensity', 'setStartupMessage', 'setState', 'setToolTo', 'setUITemplate', 'setXformManip',
            'shadingGeometryRelCtx', 'shadingLightRelCtx', 'shadingNetworkCompare', 'shadingNode', 'shapeCompare', 'shelfButton',
            'shelfTabLayout', 'shortNameOf', 'shot', 'shotRipple', 'shotTrack', 'showHelp',
            'showManipCtx', 'showSelectionInTitle', 'showShadingGroupAttrEditor', 'showWindow', 'sign', 'simplify',
            'singleProfileBirailSurface', 'size', 'sizeBytes', 'skinBindCtx', 'skinCluster', 'skinPercent',
            'smoothstep', 'smoothTangentSurface', 'snap2to2', 'snapKey', 'snapMode', 'snapshot',
            'snapshotModifyKeyCtx', 'snapTogetherCtx', 'soft', 'softMod', 'softModCtx', 'softSelect',
            'sound', 'soundControl', 'source', 'spaceLocator', 'sphere', 'sphrand',
            'spotLightPreviewPort', 'spreadSheetEditor', 'spring', 'sqrt', 'squareSurface', 'srtContext',
            'startString', 'startsWith', 'stereoCameraView', 'stereoRigManager', 'stitchAndExplodeShell', 'stitchSurface',
            'strcmp', 'stringArrayCatenate', 'stringArrayContains', 'stringArrayCount', 'stringArrayFind', 'stringArrayInsertAtIndex',
            'stringArrayRemove', 'stringArrayRemoveAtIndex', 'stringArrayRemoveDuplicates', 'stringArrayRemoveExact', 'stringArrayToString', 'stringToStringArray',
            'stripPrefixFromName', 'stroke', 'subdAutoProjection', 'subdCleanTopology', 'subdCollapse', 'subdDuplicateAndConnect',
            'subdiv', 'subdivCrease', 'subdivDisplaySmoothness', 'subdLayoutUV', 'subdListComponentConversion', 'subdMapCut',
            'subdMatchTopology', 'subdMirror', 'subdPlanarProjection', 'subdToBlind', 'subdToPoly', 'subdTransferUVsToCache',
            'substituteAllString', 'substituteGeometry', 'substring', 'suitePrefs', 'surface', 'surfaceSampler',
            'swatchDisplayPort', 'swatchRefresh', 'switchTable', 'symbolButton', 'symbolCheckBox', 'symmetricModelling',
            'system', 'tabLayout', 'tan', 'tangentConstraint', 'targetWeldCtx', 'texLatticeDeformContext',
            'texMoveContext', 'texMoveUVShellContext', 'texRotateContext', 'texScaleContext', 'texSelectContext', 'texSelectShortestPathCtx',
            'text', 'textCurves', 'textField', 'textFieldButtonGrp', 'textFieldGrp', 'textManip',
            'textToShelf', 'textureDisplacePlane', 'textureHairColor', 'texturePlacementContext', 'textureWindow', 'texWinToolCtx',
            'threePointArcCtx', 'timeCode', 'timeControl', 'timePort', 'timer', 'timerX',
            'toggle', 'toggleAxis', 'toggleWindowVisibility', 'tokenize', 'tokenizeList', 'tolerance',
            'toNativePath', 'toolBar', 'toolButton', 'toolCollection', 'toolDropped', 'toolHasOptions',
            'torus', 'toupper', 'trace', 'track', 'trackCtx', 'transferAttributes',
            'transformCompare', 'transformLimits', 'translator', 'treeLister', 'treeView', 'trim',
            'truncateFluidCache', 'truncateHairCache', 'tumble', 'tumbleCtx', 'turbulence', 'twoPointArcCtx',
            'uiRes', 'uiTemplate', 'unassignInputDevice', 'undo', 'undoInfo', 'unfold',
            'uniform', 'unit', 'unloadPlugin', 'untangleUV', 'untitledFileName', 'untrim',
            'updateAE', 'userCtx', 'uvLink', 'uvSnapshot', 'validateShelfName', 'vectorize',
            'viewCamera', 'viewClipPlane', 'viewFit', 'viewHeadOn', 'viewLookAt', 'viewManip',
            'viewSet', 'visor', 'volumeAxis', 'volumeBind', 'vortex', 'waitCursor',
            'webBrowser', 'webBrowserPrefs', 'whatIs', 'window', 'windowPref', 'wire'

            ),
        3 => array('`', 'string', 'float', 'int', 'array', '-'),
        4 => array('proc', 'global')
        ),
    'SYMBOLS' => array(
        '<', '>', '=',
        '!', '@', '~', '&', '|',
        '+','-', '*', '/', '%',
        ',', ';', '?', ':'
        ),
    'CASE_SENSITIVE' => array(
        GESHI_COMMENTS => false,
        1 => true,
        2 => true,
        3 => true,
        ),
    'STYLES' => array(
        'KEYWORDS' => array(
            1 => 'color: #b1b100;',
            2 => 'color: #000000; font-weight: bold;',
            3 => 'color: #000066;',
            4 => 'color: #001a66;'
            ),
        'COMMENTS' => array(
            1 => 'color: #666666; font-style: italic;',
            2 => 'color: #009966; font-style: italic;',
            3 => 'color: #0000ff;',
            4 => 'color: #cc0000; font-style: italic;',
            5 => 'color: #0000ff;',
            'MULTI' => 'color: #666666; font-style: italic;'
            ),
        'ESCAPE_CHAR' => array(
            0 => 'color: #000099; font-weight: bold;',
            'HARD' => 'color: #000099; font-weight: bold;'
            ),
        'BRACKETS' => array(
            0 => 'color: #009900;'
            ),
        'STRINGS' => array(
            0 => 'color: #ff0000;',
            'HARD' => 'color: #ff0000;'
            ),
        'NUMBERS' => array(
            0 => 'color: #cc66cc;'
            ),
        'METHODS' => array(
            1 => 'color: #006600;',
            2 => 'color: #006600;'
            ),
        'SYMBOLS' => array(
            0 => 'color: #339933;'
            ),
        'REGEXPS' => array(
            0 => 'color: #0000ff;',
            4 => 'color: #009999;',
            ),
        'SCRIPT' => array(
            )
        ),
    'URLS' => array(
        1 => '',
        2 => '',
        3 => 'http://perldoc.perl.org/functions/{FNAMEL}.html'
        ),
    'OOLANG' => true,
    'OBJECT_SPLITTERS' => array(
        1 => '-&gt;',
        2 => '::'
        ),
    'REGEXPS' => array(
        //Variable
        0 => '[\\$%@]+[a-zA-Z_][a-zA-Z0-9_]*',
        //File Descriptor
        4 => '&lt;[a-zA-Z_][a-zA-Z0-9_]*&gt;',
        ),
    'STRICT_MODE_APPLIES' => GESHI_NEVER,
    'SCRIPT_DELIMITERS' => array(
        ),
    'HIGHLIGHT_STRICT_BLOCK' => array(
        ),
    'PARSER_CONTROL' => array(
        'COMMENTS' => array(
            'DISALLOWED_BEFORE' => '$'
        )
    )
);

?>
