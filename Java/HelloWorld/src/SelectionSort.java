import java.util.Arrays;

public class SelectionSort {

    public static void main(String[] args) {
        int[] values = {20,39,84,76,12,9,38};

        //selectionSort(values);
        //randomSort(values);
        linearSearch(values, 9);
        //bubbleSort(values);
        //mergeSort(values);
        //binarySearch(45, values, 1, 11);
    }

    static void selectionSort(int[] arr) {
        // get the length
        int n = arr.length;
        for (int i = 0; i < n; i++) {
            int index = 0;
            int smallest = arr[i];
            for (int j = i; j < n; j++) {
                if (arr[j] < smallest) {
                    smallest = arr[j];
                    index = j;
                }
                int temp = arr[i];
                arr[i] = smallest;
                arr[index] = temp;
            }
        }
        System.out.println(Arrays.toString(arr));
    }

    static void linearSearch(int[] arr, int value) {
        for (int i = 0; i < arr.length; i++) {
            System.out.println(i);
            if (arr[i] == value) {
                System.out.println("Found! It is at index: " + i);
                return;
            }
        }
        System.out.println("the element is not in the array");
        return;
    }

    static void randomSort(int[] arr) {
        // One by one move boundary of unsorted subarray
        for (int i = 0; i < arr.length - 1; i++) {
            // Find the minimum element in unsorted array
            int min_idx = i;
            for (int j = i + 1; j < arr.length; j++)
                if (arr[j] < arr[min_idx])
                    min_idx = j;

            // Swap the found minimum element with the first element
            int temp = arr[min_idx];
            arr[min_idx] = arr[i];
            arr[i] = temp;
        }
        System.out.println(Arrays.toString(arr));
        return;
    }

    static void bubbleSort(int[] arr) {
        boolean swapped;
        do {
            swapped = false;
            for (int i = 0; i < arr.length - 1; i++) {
                if (arr[i] > arr[i + 1]) {
                    int temp = arr[i];
                    arr[i] = arr[i + 1];
                    arr[i + 1] = temp;
                    swapped = true;
                }
            }
        } while (swapped == true);
        System.out.println(Arrays.toString(arr));
        return;
    }

    static int[] mergeSort(int[] arr) {
        int n = arr.length;
        int[] left;
        int[] right;

        // create space for left and right subarrays
        if (n % 2 == 0) {
            left = new int[n / 2];
            right = new int[n / 2];
        } else {
            left = new int[n / 2];
            right = new int[n / 2 + 1];
        }

        // fill up left and right subarrays
        for (int i = 0; i < n; i++) {
            if (i < n / 2) {
                left[i] = arr[i];
            } else {
                right[i - n / 2] = arr[i];
            }
        }

        // recursively split and merge
        left = mergeSort(left);
        right = mergeSort(right);

        // merge
        return merge(left, right);
    }

    static int[] merge(int[] left, int[] right) {
        // the function for merging two sorted arrays
        // create space for the merged array
        int[] result = new int[left.length + right.length];

        // running indices
        int i = 0;
        int j = 0;
        int index = 0;

        // add until one subarray is deplete
        while (i < left.length && j < right.length) {
            if (left[i] < right[j]) {
                result[index++] = left[i++];
            } else {
                result[index++] = right[j++];
            }
        }

        // add every leftover elelment from the subarray
        while (i < left.length) {
            result[index++] = left[i++];
        }

        // only one of these two while loops will be executed
        while (j < right.length) {
            result[index++] = right[j++];
        }

        return result;
    }

    static boolean binarySearch(int v, int[] arr, int low, int high) {
        if (low > high) {
            System.out.println("not found");
            return false;
        }

        int middle = (low + high) / 2;

        if (v == arr[middle]) {
            System.out.println("found! It is at " + middle);
            return true;
        } else if (v > arr[middle]) {
            return binarySearch(v, arr, middle + 1, high);
        } else {
            return binarySearch(v, arr, low, middle - 1);
        }
    }
}

