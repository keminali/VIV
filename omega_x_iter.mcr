#!MC 1410
# set k as a variable,  3 loops
$!VarSet |num|=9000
$!LOOP 38
$!VarSet |num|+=25
$!ReadDataSet  '"STANDARDSYNTAX" "1.0" "FILELIST_Files" "2" "E:\gap1ur5\gap_1-1-0|num|.cas" "E:\gap1ur5\gap_1-1-0|num|.dat" "LoadOption" "MultipleCaseAndData" "UnsteadyOption" "ReadTimeFromDataFiles" "AssignStrandIDs" "Yes" "LoadAdditionalQuantities" "Yes" "SaveUncompressedFiles" "No"'
  DataSetReader = 'Fluent Data Loader'
$!ExtendedCommand 
  CommandProcessorID = 'Extract Precise Line'
  Command = 'XSTART = 1.1 YSTART = 0.15 ZSTART = 0 XEND = 1.1 YEND = 0.15 ZEND = 0.6 NUMPTS = 120 EXTRACTTHROUGHVOLUME = T EXTRACTTOFILE = F '
# calculate x vorticity
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Calculate Function=\'XVORTICITY\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'T\' UseMorePointsForFEGradientCalculations=\'F\''
$!TwoDAxis YDetail{VarNum = 56}
# export data
$!WriteDataSet  "E:\gap1ur5\post\gap_1-1-|num|.dat"
  IncludeText = No
  IncludeGeom = No
  IncludeDataShareLinkage = Yes
  ZoneList =  [9]
  VarPositionList =  [56]
  Binary = No
  UsePointFormat = Yes
  Precision = 9
  TecplotVersionToWrite = TecplotCurrent
# xy plot
$!PlotType = Cartesian2D
$!ActiveFieldMaps -= [1-8]
$!TwoDAxis XDetail{VarNum = 3}
$!TwoDAxis YDetail{VarNum = 56}
$!Pick AddAtPosition
  X = 2.97481243301
  Y = 4.97454448017
  ConsiderStyle = Yes
$!FieldLayers ShowMesh = Yes
$!PlotType = Cartesian3D
$!Pick AddAtPosition
  X = 1.59431939979
  Y = 3.34539121115
  ConsiderStyle = Yes
$!Pick AddAtPosition
  X = 1.72293676313
  Y = 2.11066452304
  ConsiderStyle = Yes
$!PlotType = Cartesian2D
$!ExportSetup ImageWidth = 1049
# export image
$!ExportSetup ExportFName = 'E:\gap1ur5\post\gap_1-1-|num|.png'
$!Export 
  ExportRegion = CurrentFrame
$!ENDLOOP