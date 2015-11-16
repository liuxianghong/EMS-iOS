//
//  Config.h
//  chartView
//
//  Created by rsaif on 13-10-8.
//  Copyright (c) 2013年 rsaif. All rights reserved.
//

#ifndef chartView_Config_h
#define chartView_Config_h

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height


#define IS_IPHONE_5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#endif
