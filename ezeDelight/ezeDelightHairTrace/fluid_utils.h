/*
   Apply a bias to a given value in the [0, 1] range.
   The output value is in the [0, 1] range as well.
*/ 
float fluid_bias(float bias, value)
{
	if (bias == 0.0)
	{
		return value;
	}
	else
	{
		float b = bias < -0.99 ? -0.99 : bias;
		float x = value < 0.0 ? 0.0 : value;
			
		return pow(x, (b - 1.0) / (-b - 1.0));
	}
}

float desaturate(color x)
{
	return  (x[0] + x[1] + x[2] ) / 3;
}

point abs_point(point p)
{
	return point( abs(p[0]), abs(p[1]), abs(p[2]) );
}

float evalFluid_float(
		float i_fluid_id;
		float i_input;
		point i_point_position;
		point i_point_center;
		float i_scale;)
{
	float input_count = 1.0;
	float inputs[] = { i_input };
	float outputs[] = { 0.0 };

	maya_fluid_evaluate(
			i_fluid_id,
			i_point_position,
			i_point_center,
			i_scale,
			input_count,
			inputs,
			outputs);

	return outputs[0];
}

/*
	fluid_dropoff

	Handles maya's drop off functions.
*/
float fluid_dropoff(
		float i_fluid_id;
		point i_point_position;
		point i_point_center;
		point i_fluid_size;
		float shape;
		float edge)
{
	point npp = (i_point_position-i_point_center)/i_fluid_size;

	float gradient( float pos, edge )
	{
		float ret;
		if( edge<0.5 )
		{
			ret = 1-pos;
			ret = 1-(ret-(1-2*edge))/(2*edge);
		}
		else
		{
			ret = pos;
			ret = (ret - (2*(edge-0.5)))/(1-2*(edge-0.5));
		}
		return clamp(ret, 0, 1);
	}

	if (edge == 0.0)
	{
		return 1;
	}
	
	if (shape == 0.0)
	{
		/* Off */
		return 1;
	}

	if (shape == 1)
	{
		/* Sphere */
		float ret = length(vector(abs_point(npp)));
		ret = (ret-1+edge)/edge;
		ret = 1-clamp(ret, 0, 1);
		return ret;
	}

	if (shape == 2) 
	{
		/* Cube */
		point pbuf = abs_point(npp);
		pbuf = point(xcomp(pbuf)-1+edge, ycomp(pbuf)-1+edge, zcomp(pbuf)-1+edge);
		pbuf = point(xcomp(pbuf)/edge, ycomp(pbuf)/edge, zcomp(pbuf)/edge);
		/* Clamping a point produces a warning. Since wanrings are like errors
		 * in 3DFM it's necessary to use following trick. */
		pbuf = point(
				clamp(pbuf[0], 0, 1),
				clamp(pbuf[1], 0, 1),
				clamp(pbuf[2], 0, 1) );
		return 1-clamp(length(vector(pbuf)), 0, 1);
	}

	float pos;

	if (shape == 5)
		/* X Gradient */
		pos = 0.5 - xcomp(npp)*0.5;
	else if (shape == 6)
		/* Y Gradient */
		pos = 0.5 - ycomp(npp)*0.5;
	else if (shape == 7)
		/* Z Gradient */
		pos = 0.5 - zcomp(npp)*0.5;
	else if (shape == 8)
		/* -X Gradient */
		pos = xcomp(npp)*0.5 + 0.5;
	else if (shape == 9)
		/* -Y Gradient */
		pos = ycomp(npp)*0.5 + 0.5;
	else if (shape == 10)
		/* -Z Gradient */
		pos = zcomp(npp)*0.5 + 0.5;
	else if (shape == 12)
	{
		/* Use Falloff Grid */
		pos = evalFluid_float(
				i_fluid_id,
				12,
				i_point_position,
				i_point_center,
				1.0);
	}
	else
	{
		pos = 0;
	}

	return gradient(pos, edge);
}

