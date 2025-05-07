-- Modify VUDU test plans names from 128k to 192k
Use AssetLibrary
Update AlTestPlan set Name ='TS H.264 1920x1080 V7.890M AC3 2.0 A192k High 4.0 10sGOP v361'  where Name like '%v361'
Update AlTestPlan set Name ='TS H.264 1920x1080 V5.890M AC3 2.0 A192k High 4.0 10sGOP v362'  where Name like '%v362'
Update AlTestPlan set Name ='TS H.264 1920x1080 V3.890M AC3 2.0 A192k High 4.0 10sGOP v363'  where Name like '%v363'
Update AlTestPlan set Name ='TS H.264 1920x1080 V2.540M AC3 2.0 A192k High 4.0 10sGOP v364'  where Name like '%v364'
Update AlTestPlan set Name ='TS H.264 1280x720 V3.850M AC3 2.0 A192k High 4.0 10sGOP v365'  where Name like '%v365'
Update AlTestPlan set Name ='TS H.264 1280x720 V2.890M AC3 2.0 A192k High 4.0 10sGOP v366'  where Name like '%v366'
Update AlTestPlan set Name ='TS H.264 1280x720 V1.830M AC3 2.0 A192k High 4.0 10sGOP v367'  where Name like '%v367'
Update AlTestPlan set Name ='TS H.264 1280x720 V1.156M AC3 2.0 A192k High 4.0 10sGOP v368'  where Name like '%v368'
Update AlTestPlan set Name ='TS H.264 720x480 v1.400M AC3 2.0 A192k High 4.0 10sGOP v369'  where Name like '%v369'
Update AlTestPlan set Name ='TS H.264 720x480 V1.156M AC3 2.0 A192k High 4.0 10sGOP v370'  where Name like '%v370'
Update AlTestPlan set Name ='TS H.264 720x480 V0.708M AC3 2.0 A192k High 4.0 10sGOP v371'  where Name like '%v371'
