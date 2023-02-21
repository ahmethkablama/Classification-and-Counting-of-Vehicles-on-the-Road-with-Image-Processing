# Classification and Counting of Vehicles on the Road with Image- rocessing
Image processing project in MatLab that counts the vehicles moving on the road by distinguishing **between big and small**.

While developing the project, MatLab Computer Vision Toolbox was used. Many operations such as detecting moving vehicles, framing, and determining the center point were performed with MatLab Computer Vision Toolbox.

```mermaid
graph LR
A(Video Frame) --> B(Gussian Fr.)
B --> D(Computer Vision Fr.)
D --> E(Lines Fr.)
E --> F(Counter Algorithm)
F --> A
```

## Capture or Acquire a Video

The project is built on a video previously taken from the overpass. For your own project, you should shoot or provide a video that will see the vehicles from the top.

![1111](https://user-images.githubusercontent.com/29388602/220310651-857b763f-6bfe-4dcb-9871-a1de786bfaa3.gif)


## Lowering the Resolution and Narrowing the View Angle

Since the video shooting angle and video resolution are high, the video was trimmed so that the first man could only see the vehicles, and the resolution was reduced.

![2222](https://user-images.githubusercontent.com/29388602/220310672-a706eb8a-d5c3-476d-917b-a6eeea3a0be7.gif)


## Gaussian Filtering and Noise Removal

A special Gaussian filter was used to detect moving objects. Pixels lower than a certain value have been cleaned to remove the surrounding noise.

![3333](https://user-images.githubusercontent.com/29388602/220310688-ad7e6d5e-417c-43cc-a138-b373eebc4f17.gif)


## Engulfing Vehicles and Determining the Center Point with Computer Vision

With the Computer Vision library available in MatLab, we squared the moving objects (vehicles) that emerged with the gaussian filter and determined the center point and got the coordinate information.

![4444](https://user-images.githubusercontent.com/29388602/220310696-321fc9b5-4236-4b89-b070-894c0e73d4cd.gif)


## Counting Algorithm with Double Line Method

A double line counter mechanism is used for vehicle counting. This algorithm works as follows;

1. When the vehicle comes to the first line (white line), it counts the vehicle in that lane and closes the counting process in the lane.
2. When the vehicle comes to the second line (black line), it turns on the vehicle counting system in that lane again.

The algorithm that performs a kind of switch operation basically works by turning on and off the lane counting operation.

![5555](https://user-images.githubusercontent.com/29388602/220310711-2fe4213f-9f01-426a-8219-8a456b8e2287.gif)


## Displaying Vehicle Numbers on the Screen

Finally, the number of vehicles assigned to the variables in the background is completed by adding counters and colored lines on the screen.

![6666](https://user-images.githubusercontent.com/29388602/220310728-2639300a-a87c-4e69-85bb-0ff2f9ac911a.gif)


