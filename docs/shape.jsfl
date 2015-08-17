fl.outputPanel.clear();

var doc = fl.getDocumentDOM();
doc.selectAll();

for (var key in doc.selection)
{
	var item = doc.selection[key];
	
	if (item.elementType == "shape")
	{
		for (var n in item.contours)
		{
			printContour(item.contours[n]);
		}
	}
	else
	{
		fl.trace(item.elementType)
	}
}

function printContour(contour)
{
	fl.trace("---------------------------");
	fl.trace("contour.interior: " + contour.interior);
	fl.trace("contour.orientation: " + contour.orientation);
	
	var fill = contour.fill
	fl.trace("\tfill.bitmapIsClipped: " + fill.bitmapIsClipped);
	fl.trace("\tfill.bitmapPath: " + fill.bitmapPath);
	fl.trace("\tfill.color: " + fill.color);
	fl.trace("\tfill.colorArray: " + fill.colorArray);
	fl.trace("\tfill.focalPoint: " + fill.focalPoint);
	fl.trace("\tfill.linearRGB: " + fill.linearRGB);
	fl.trace("\tfill.overflow: " + fill.overflow);
	if (fill.posArray)
	{
		fl.trace("\tfill.posArray: " + fill.posArray);
	}
	if (fill.matrix)
	{
		var mat = fill.matrix
		fl.trace("\tfill.matrix: a=" + mat.a + ", b=" + mat.b + ", c=" + mat.c + ", d=" + mat.d + ", tx=" + mat.tx + ", ty=" + mat.ty);
	}
	
	fl.trace("\tfill.style: " + fill.style);
}